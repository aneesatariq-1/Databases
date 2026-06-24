# 1. Libraries 
import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_absolute_error, r2_score
import joblib

# 2. Create Sample data (If there is no csv)
# Manual - 100 houses data

np.random.seed(42)  # Takisha har baar same data aay

n_houses = 100

# Features (Inputs)
square_feet = np.random.randint(800, 3500, n_houses)      # Range 800 to 3500 sq ft
bedrooms = np.random.randint(1, 5, n_houses)              # 1 to 4 bedrooms
age = np.random.randint(0, 50, n_houses)                  # 0 to 50 years old

# Target (Output - Price)
# Formula: Price = (sqft * 120) + (bedrooms * 8000) - (age * 500) + random_variation
price = (square_feet * 120) + (bedrooms * 8000) - (age * 500) + np.random.randint(-20000, 20000, n_houses)

# DataFrame mein convert karo
data = pd.DataFrame({
    'square_feet': square_feet,
    'bedrooms': bedrooms,
    'age': age,
    'price': price
})

print("=" * 50)
print("📊 DATASET INFO")
print("=" * 50)
print(f"Total houses: {len(data)}")
print(f"\nFirst 5 rows:")
print(data.head())
print(f"\nColumn names: {list(data.columns)}")

# 3. Seperate Features (X) and Target (y) 
X = data[['square_feet', 'bedrooms', 'age']]  # Input features
y = data['price']                               # Output (price)

# 4. Splitting data into train and test (80% train, 20% test)
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

print(f"\n📊 Data Split:")
print(f"Training data: {len(X_train)} houses")
print(f"Testing data: {len(X_test)} houses")

# 5. Create linear regression model
model = LinearRegression()
model.fit(X_train, y_train)

print("\n" + "=" * 50)
print("🤖 MODEL TRAINED SUCCESSFULLY!")
print("=" * 50)

# 6. Evaluate the model on testing data
y_pred = model.predict(X_test)

# Calculate the matrices
mae = mean_absolute_error(y_test, y_pred)
r2 = r2_score(y_test, y_pred)

print(f"\n📈 Model Performance on Test Data:")
print(f"   Mean Absolute Error: ${mae:,.2f}")
print(f"   R² Score: {r2:.4f} (0 to 1 - closer to 1 is better)")

# 7. Display model coefficients (feature importance)
print(f"\n📐 Model Coefficients (Formula):")
print(f"   Price = {model.intercept_:,.2f}")
print(f"   + ({model.coef_[0]:,.2f} × square_feet)")
print(f"   + ({model.coef_[1]:,.2f} × bedrooms)")
print(f"   + ({model.coef_[2]:,.2f} × age)")

# 8. Save the model for future use
joblib.dump(model, 'house_price_model.pkl')
print(f"\n💾 Model saved as 'house_price_model.pkl'")

print("\n✅ Training Complete! Run 'predict_price.py' to make predictions.")