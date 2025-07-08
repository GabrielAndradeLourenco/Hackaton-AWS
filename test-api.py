import requests
import json

# URLs da API (ajustar após deploy)
BASE_URL = "https://your-api-gateway-url.amazonaws.com/prod"

def test_create_review():
    """Testa criação de review"""
    url = f"{BASE_URL}/reviews"
    
    payload = {
        "user_name": "John Silva",
        "score": 4,
        "description": "Very good product, arrived quickly. Only the packaging could be better.",
        "product_id": "PROD-001"
    }
    
    response = requests.post(url, json=payload)
    print("=== CRIAR REVIEW ===")
    print(f"Status: {response.status_code}")
    print(f"Response: {response.json()}")
    print()

def test_admin_reviews():
    """Testa listagem admin com análise profunda"""
    url = f"{BASE_URL}/admin/reviews?product_id=PROD-001"
    
    response = requests.get(url)
    print("=== ADMIN REVIEWS ===")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")
    print()

def test_store_reviews():
    """Testa listagem simplificada para loja"""
    url = f"{BASE_URL}/store/reviews?product_id=PROD-001"
    
    response = requests.get(url)
    print("=== STORE REVIEWS ===")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")
    print()

def test_list_products():
    """Testa listagem de produtos"""
    url = f"{BASE_URL}/products"
    
    response = requests.get(url)
    print("=== LIST PRODUCTS ===")
    print(f"Status: {response.status_code}")
    print(f"Response: {json.dumps(response.json(), indent=2)}")
    print()

if __name__ == "__main__":
    # Executar testes
    test_list_products()
    test_create_review()
    test_admin_reviews()
    test_store_reviews()