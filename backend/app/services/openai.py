import openai
from openai import OpenAI
import os
import json
from typing import Dict, Any

# Initialize OpenAI client
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def get_openai_assessment(text: str) -> Dict[str, Any]:
    """
    Menggunakan OpenAI untuk menganalisis apakah lowongan kerja asli atau palsu
    """
    try:
        prompt = f"""
Analisis apakah lowongan kerja berikut ini asli atau palsu. Berikan penilaian berdasarkan:

1. Kredibilitas informasi
2. Struktur penawaran (gaji, syarat, dll)
3. Red flags yang mencurigakan
4. Profesionalitas deskripsi

Text lowongan:
{text}

Berikan response dalam format JSON dengan struktur:
{{
    "label": "asli" atau "palsu",
    "confidence": skor_confidence_0-100,
    "alasan": ["alasan1", "alasan2", ...],
    "red_flags": ["flag1", "flag2", ...] atau []
}}
"""

        response = client.chat.completions.create(
            model="gpt-3.5-turbo",  # atau "gpt-4" jika tersedia
            messages=[
                {"role": "system", "content": "Anda adalah expert dalam mendeteksi lowongan kerja palsu. Berikan analisis yang objektif dan berbasis bukti."},
                {"role": "user", "content": prompt}
            ],
            temperature=0.3,
            max_tokens=1000
        )
        
        # Parse response
        result_text = response.choices[0].message.content.strip()
        
        # Try to parse JSON response
        try:
            result = json.loads(result_text)
            
            # Validate required fields
            required_fields = ["label", "confidence", "alasan"]
            for field in required_fields:
                if field not in result:
                    raise ValueError(f"Missing required field: {field}")
            
            # Normalize label
            if result["label"].lower() in ["asli", "legitimate", "real"]:
                result["label"] = "asli"
            elif result["label"].lower() in ["palsu", "fake", "scam"]:
                result["label"] = "palsu"
            else:
                result["label"] = "tidak_yakin"
                
            return {
                "label": result["label"],
                "skor": result.get("confidence", 50),
                "alasan": result.get("alasan", []),
                "red_flags": result.get("red_flags", []),
                "method": "openai"
            }
            
        except json.JSONDecodeError:
            # Fallback parsing if JSON fails
            if "palsu" in result_text.lower() or "fake" in result_text.lower():
                label = "palsu"
            elif "asli" in result_text.lower() or "legitimate" in result_text.lower():
                label = "asli"
            else:
                label = "tidak_yakin"
                
            return {
                "label": label,
                "skor": 50,
                "alasan": ["Analisis OpenAI (parsing fallback)"],
                "method": "openai_fallback"
            }
            
    except openai.APIError as e:
        # Handle API errors (4xx, 5xx)
        print(f"OpenAI API Error: {e}")
        raise Exception(f"OpenAI API Error: {str(e)}")
        
    except openai.RateLimitError as e:
        # Handle rate limit specifically
        print(f"OpenAI Rate Limit Error: {e}")
        raise Exception(f"OpenAI Rate Limit: {str(e)}")
        
    except openai.APIConnectionError as e:
        # Handle connection errors
        print(f"OpenAI Connection Error: {e}")
        raise Exception(f"OpenAI Connection Error: {str(e)}")
        
    except openai.AuthenticationError as e:
        # Handle authentication errors
        print(f"OpenAI Authentication Error: {e}")
        raise Exception(f"OpenAI Authentication Error: {str(e)}")
        
    except Exception as e:
        # Handle any other errors
        print(f"Unexpected error in OpenAI assessment: {e}")
        raise Exception(f"OpenAI Assessment Error: {str(e)}")

def combine_assessments(rule_result: Dict[str, Any], openai_result: Dict[str, Any]) -> Dict[str, Any]:
    """
    Menggabungkan hasil rule-based dan OpenAI assessment
    """
    try:
        # Get scores
        rule_score = rule_result.get("skor", 0)
        openai_score = openai_result.get("skor", 50)
        
        # Get labels
        rule_label = rule_result.get("label", "tidak_yakin")
        openai_label = openai_result.get("label", "tidak_yakin")
        
        # Combine reasons
        rule_reasons = rule_result.get("alasan", [])
        openai_reasons = openai_result.get("alasan", [])
        combined_reasons = rule_reasons + openai_reasons
        
        # Decision logic
        if rule_label == openai_label:
            # Both agree
            final_label = rule_label
            final_score = max(rule_score, openai_score)
            primary_method = "combined_agreement"
        elif openai_score > 70:
            # OpenAI is confident
            final_label = openai_label
            final_score = openai_score
            primary_method = "openai_confident"
        elif rule_score > 70:
            # Rule-based is confident
            final_label = rule_label
            final_score = rule_score
            primary_method = "rule_based_confident"
        else:
            # Neither is confident, use weighted average
            # Give slight preference to OpenAI if both are uncertain
            if openai_score >= rule_score:
                final_label = openai_label
                final_score = (openai_score * 0.6) + (rule_score * 0.4)
            else:
                final_label = rule_label
                final_score = (rule_score * 0.6) + (openai_score * 0.4)
            primary_method = "weighted_combination"
        
        return {
            "label": final_label,
            "skor": int(final_score),
            "alasan": combined_reasons,
            "primary_method": primary_method,
            "rule_based_score": rule_score,
            "openai_score": openai_score,
            "red_flags": openai_result.get("red_flags", [])
        }
        
    except Exception as e:
        print(f"Error in combine_assessments: {e}")
        # Fallback to rule-based
        return {
            "label": rule_result.get("label", "tidak_yakin"),
            "skor": rule_result.get("skor", 0),
            "alasan": rule_result.get("alasan", []) + [f"Error combining assessments: {str(e)}"],
            "primary_method": "rule_based_fallback"
        }