import joblib
import numpy as np

# 1. Load save model
try:
    model = joblib.load('house_price_model.pkl')
    print("✅ Model loaded successfully!")
except FileNotFoundError:
    print("❌ Model file not found! You have to run 'house_price_model.py' first.")
    exit()

print("\n" + "=" * 50)
print("🏠 HOUSE PRICE PREDICTION SYSTEM")
print("=" * 50)

# 2. Input from user
print("\nEnter house details:")

while True:
    try:
        sqft = float(input("   Square Feet (e.g., 1500): "))
        if sqft > 0:
            break
        else:
            print("   Please enter a positive number.")
    except ValueError:
        print("   Please enter a valid number.")

while True:
    try:
        bedrooms = int(input("   Number of Bedrooms (e.g., 3): "))
        if bedrooms > 0:
            break
        else:
            print("   Please enter a positive number.")
    except ValueError:
        print("   Please enter a valid integer.")

while True:
    try:
        age = int(input("   Age of House (years, e.g., 10): "))
        if age >= 0:
            break
        else:
            print("   Please enter 0 or a positive number.")
    except ValueError:
        print("   Please enter a valid number.")

# 3. Prediction 
features = np.array([[sqft, bedrooms, age]])
predicted_price = model.predict(features)[0]

# 4. Display result
print("\n" + "=" * 50)
print("🔮 PREDICTION RESULT")
print("=" * 50)
print(f"   House Details:")
print(f"   • Square Feet: {sqft:,.0f} sq ft")
print(f"   • Bedrooms: {bedrooms}")
print(f"   • Age: {age} years")
print(f"\n   💰 Estimated Price: ${predicted_price:,.2f}")
print("=" * 50)

# 5. Additional information
print("\n📌 Note: This is an estimate based on the training data.")
print("   Actual market prices may vary due to location and other factors.")