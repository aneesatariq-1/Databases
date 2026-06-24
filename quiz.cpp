#include <iostream>
#include <fstream>
#include <string>
#include <vector>
using namespace std;

// Template class
template <typename T>
class Display {
public:
    static void show(const T& item) {
        cout << item << endl;
    }
};

// Abstract class
class Panel {
public:
    virtual void display() const = 0;
    virtual ~Panel() {}
};

// Base Question class
class Question {
protected:
    string query;
    string options[4];
    char correctOption;

public:
    virtual void input() {
        cin.ignore();
        cout << "Enter Question: ";
        getline(cin, query);
        for (int i = 0; i < 4; i++) {
            cout << "Option " << i + 1 << ": ";
            getline(cin, options[i]);
        }
        cout << "Correct option (1-4): ";
        cin >> correctOption;
    }

    virtual void show() const {
        cout << "\n" << query << endl;
        for (int i = 0; i < 4; i++) {
            cout << (i + 1) << ". " << options[i] << endl;
        }
    }

    virtual char getCorrect() const { return correctOption; }
//keyword search kar raha hai keh given keyword exist karta hai ya nahia
    bool match(const string& keyword) const {
        return query.find(keyword) != string::npos;
    }

    void save(ofstream& out) {
        int len = query.size();
        out.write((char*)&len, sizeof(len));
        out.write(query.c_str(), len);
        for (int i = 0; i < 4; i++) {
            len = options[i].size();
            out.write((char*)&len, sizeof(len));
            out.write(options[i].c_str(), len);
        }
        out.write((char*)&correctOption, sizeof(correctOption));
    }
//samaghan wla function hai yeh load ka 
    void load(ifstream& in) {
        int len;
        char* buf;

        in.read((char*)&len, sizeof(len));
        buf = new char[len + 1];
        in.read(buf, len);
        buf[len] = '\0';
        query = buf;
        delete[] buf;

        for (int i = 0; i < 4; i++) {
            in.read((char*)&len, sizeof(len));
            buf = new char[len + 1];
            in.read(buf, len);
            buf[len] = '\0';
            options[i] = buf;
            delete[] buf;
        }

        in.read((char*)&correctOption, sizeof(correctOption));
    }
};

// Admin Class
class Admin : virtual public Panel {
public:
    void addQuestion(const string& filename) {
        Question q;
        q.input();
        ofstream out(filename.c_str(), ios::binary | ios::app);
        q.save(out);
        out.close();
        cout << "Question added.\n";
    }

    void display() const {
        cout << "Admin Panel\n";
    }
};

// Student Class
class Student : virtual public Panel {
public:
    void takeQuiz(const string& filename) {
        try {
            ifstream in(filename.c_str(), ios::binary);
            if (!in)
                throw "Quiz file not found!";

            Question q;
            int correct = 0, total = 0;
            char ans;

            while (in.peek() != EOF) {
                q.load(in);
                q.show();
                cout << "Your answer (1-4): ";
                cin >> ans;
                if (ans == q.getCorrect())
                    correct++;
                total++;
            }

            in.close();
            cout << "\nCorrect: " << correct << ", Total: " << total;
            cout << ", Score: " << (total ? (correct * 100.0 / total) : 0) << "%\n";
        }
        catch (const char* msg) {
            cout << "Error: " << msg << endl;
        }
    }

    void display() const {
        cout << "Student Panel\n";
    }
};

// QuizMaster Class
class QuizMaster : public Admin, public Student {
public:
    void display() const {
        cout << "QuizMaster Access\n";
    }

    void searchQuestion(const string& filename, const string& keyword) {
        try {
            ifstream in(filename.c_str(), ios::binary);
            if (!in)
                throw "File not found!";

            Question q;
            bool found = false;

            while (in.peek() != EOF) {
                q.load(in);
                if (q.match(keyword)) {
                    cout << "\nMatch Found:\n";
                    q.show();
                    found = true;
                }
            }

            in.close();

            if (!found)
                cout << "No matching question found.\n";
        }
        catch (const char* msg) {
            cout << "Search Error: " << msg << endl;
        }
    }

    void updateQuestion(const string& filename, const string& keyword) {
        try {
            ifstream in(filename.c_str(), ios::binary);
            if (!in)
                throw "File not found for update!";

            ofstream temp("temp.bin", ios::binary);
            Question q;
            bool updated = false;

            while (in.peek() != EOF) {
                q.load(in);
                if (!updated && q.match(keyword)) {
                    cout << "Match found. Enter new details:\n";
                    q.input();
                    updated = true;
                }
                q.save(temp);
            }

            in.close();
            temp.close();

            remove(filename.c_str());
            rename("temp.bin", filename.c_str());

            if (updated)
                cout << "Question updated.\n";
            else
                cout << "No match found for update.\n";
        }
        catch (const char* msg) {
            cout << "Update Error: " << msg << endl;
        }
    }

    void deleteQuestion(const string& filename, const string& keyword) {
        try {
            ifstream in(filename.c_str(), ios::binary);
            if (!in)
                throw "File not found for delete!";

            ofstream temp("temp.bin", ios::binary);
            Question q;
            bool deleted = false;

            while (in.peek() != EOF) {
                q.load(in);
                if (!deleted && q.match(keyword)) {
                    cout << "Deleted Question:\n";
                    q.show();
                    deleted = true;
                    continue;
                }
                q.save(temp);
            }

            in.close();
            temp.close();

            remove(filename.c_str());
            rename("temp.bin", filename.c_str());

            if (deleted)
                cout << "Question deleted.\n";
            else
                cout << "No question matched to delete.\n";
        }
        catch (const char* msg) {
            cout << "Delete Error: " << msg << endl;
        }
    }
};

// Main Program
int main() {
    QuizMaster qm;
    vector<Panel*> users;
    users.push_back(&qm);
    string filename = "quiz.bin";
    int choice;

    while (true) {
        cout << "\n===== QUIZ SYSTEM MENU =====\n";
        cout << "1. Add Question (Admin)\n";
        cout << "2. Take Quiz (Student)\n";
        cout << "3. Display Role\n";
        cout << "4. Search Question\n";
        cout << "5. Update Question\n";
        cout << "6. Delete Question\n";
        cout << "7. Exit\n";
        cout << "Enter choice: ";
        cin >> choice;

        switch (choice) {
        case 1:
            qm.addQuestion(filename);  // ? direct call
            break;
        case 2:
            qm.takeQuiz(filename);     // ? direct call
            break;
        case 3:
            users[0]->display();
            break;
        case 4: {
            string key;
            cin.ignore();
            cout << "Enter keyword to search: ";
            getline(cin, key);
            qm.searchQuestion(filename, key);
            break;
        }
        case 5: {
            string key;
            cin.ignore();
            cout << "Enter keyword to update: ";
            getline(cin, key);
            qm.updateQuestion(filename, key);
            break;
        }
        case 6: {
            string key;
            cin.ignore();
            cout << "Enter keyword to delete: ";
            getline(cin, key);
            qm.deleteQuestion(filename, key);
            break;
        }
        case 7:
            cout << "Goodbye!\n";
            return 0;
        default:
            cout << "Invalid choice!\n";
        }
    }
}