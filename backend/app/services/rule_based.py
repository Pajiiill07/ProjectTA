from typing import List
import re

def rule_based(deskripsi: str) -> dict:
    """
    Evaluasi hanya teks deskripsi lowongan kerja menggunakan rule-based filtering.
    """
    deskripsi = deskripsi.lower()
    rules_triggered = []

    # Rule 1
    if any(keyword in deskripsi for keyword in ["biaya pendaftaran", "transfer biaya", "uang administrasi"]):
        rules_triggered.append("Permintaan biaya pendaftaran")

    # Rule 2
    if re.search(r'\b(wa\.me|bit\.ly|t\.me|wa\s?\d+|\+62|08\d{8,})\b', deskripsi):
        rules_triggered.append("Kontak pribadi atau tautan tidak resmi")

    # Rule 3
    if any(keyword in deskripsi for keyword in ["gaji besar", "gaji tinggi", "penghasilan fantastis"]):
        rules_triggered.append("Janji gaji tinggi tanpa detail")

    # Rule 4
    if "langsung kerja" in deskripsi and "interview" not in deskripsi:
        rules_triggered.append("Langsung kerja tanpa proses seleksi")

    # Rule 5
    if re.search(r"(blogspot|bit\.ly|wordpress|shorturl|tinyurl)", deskripsi):
        rules_triggered.append("Tautan ke web tidak resmi")

    # Rule 6
    if any(phrase in deskripsi for phrase in ["100% diterima", "pasti diterima", "tanpa syarat"]):
        rules_triggered.append("Klaim pasti diterima / tanpa syarat")

    score = len(rules_triggered) * 20  
    label = "palsu" if score >= 50 else "asli"

    return {
        "label": label,
        "skor": score,
        "alasan": rules_triggered
    }
