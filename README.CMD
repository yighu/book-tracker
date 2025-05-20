# app.py
...（略，原始內容保留）...

# README.CMD

## Book CRUD Web Application (Flask)

This is a simple Python Flask web app to manage a collection of books. It supports:

- Create, Read, Update, Delete (CRUD)
- Search by title or author
- Pagination

---

### ✅ Setup (Safe in Local Environment)

1. **Clone or download the project files.**

2. **Create a virtual environment:**
```bash
python3 -m venv venv
```

3. **Activate the virtual environment:**
- On **macOS/Linux**:
```bash
source venv/bin/activate
```
- On **Windows**:
```bash
venv\Scripts\activate
```

4. **Install the dependencies:**
```bash
pip install -r requirements.txt
```

5. **Run the app:**
```bash
python app.py
```
Then open your browser at [http://127.0.0.1:5000](http://127.0.0.1:5000)

---

### 🗂 Directory Structure
```
project-folder/
├── app.py
├── requirements.txt
├── README.CMD
└── templates/
    ├── index.html
    ├── create.html
    └── update.html
```

---

### 🔚 Deactivating
After you're done, deactivate the virtual environment:
```bash
deactivate
```

---

### 📎 Notes
- This app uses SQLite (`books.db`) by default.
- Data is stored in the project folder and won't affect your system.
- You can reset the data by deleting `books.db`.

---

Happy coding!

