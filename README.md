# 🚗 Parkzo

**Parkzo** is a smart and secure vehicle entry management system built for Indian residential societies, commercial buildings, and gated communities. It replaces the outdated manual register system with an AI-powered, offline-capable mobile app and a feature-rich Windows desktop application.

---

## 🔍 Problem Statement

Traditional gate entry processes are manual, time-consuming, and unreliable. They lack security, digital record-keeping, and are prone to human error. Parkzo offers an automated solution to digitize and secure vehicle entry logs at society gates using AI and real-time data synchronization.

---

## 🌟 Key Features

### 📱 Guard Mobile App (Flutter)
- Detects vehicle number from images using AI model
- Works seamlessly without internet; syncs data when online
- Supports **Phone Login** and **Google Login**
- Guard can:
  - Log entries quickly by scanning number plates
  - Work offline at remote gates
- Captures:
  - Vehicle Number (auto-detected from photo)
  - Date & Time of entry
  - Location coordinates
  - Guard info

### 🖥️ Windows Admin App (Flutter)
- Admin login system
- Admin can:
  - Add Buildings
  - Add Gates under each Building
  - Add Guards and assign them to specific gates
  - Generate login credentials for Guards
  - View real-time data of scanned entries
  - Filter logs by gate, date, guard, or vehicle number

---

## 🧠 Technology Stack

- **AI Model** – For number plate recognition 
- **Firebase** – For real-time cloud storage and sync
- **Flutter** – For both mobile and Windows apps

---

## 🧩 System Workflow

1. **Admin registers and logs into the Windows app**
2. Admin adds:
   - Building(s)
   - Gates under each building
   - Guard profiles and credentials
3. Guard receives login credentials from the admin
4. Guard logs into the mobile app (via Phone or Google)
5. Guard scans vehicles; data is stored **with location** and synced to Firebase
6. Admin views and manages all data from the Windows app

---

## 📹 Demo Video




https://github.com/user-attachments/assets/0f3b2c16-4599-4f79-b7ed-1cdc9aa5a801




This project is licensed under the MIT License.

---

> **Parkzo** — Making Indian gate entries smart, secure, and seamless.
