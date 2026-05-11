import pytest
from tests.conftest import client

def test_create_category(client):
    response = client.post("/api/v1/categories/", json={"category_name": "Electronics"})
    assert response.status_code == 201
    data = response.json()
    assert data["category_name"] == "Electronics"
    assert "id" in data

def test_list_categories(client):
    client.post("/api/v1/categories/", json={"category_name": "Electronics"})
    response = client.get("/api/v1/categories/")
    assert response.status_code == 200
    assert len(response.json()) >= 1

def test_get_category(client):
    create_resp = client.post("/api/v1/categories/", json={"category_name": "Electronics"})
    cat_id = create_resp.json()["id"]
    response = client.get(f"/api/v1/categories/{cat_id}")
    assert response.status_code == 200
    assert response.json()["id"] == cat_id

def test_update_category(client):
    create_resp = client.post("/api/v1/categories/", json={"category_name": "Electronics"})
    cat_id = create_resp.json()["id"]
    response = client.put(f"/api/v1/categories/{cat_id}", json={"category_name": "Updated"})
    assert response.status_code == 200
    assert response.json()["category_name"] == "Updated"

def test_delete_category(client):
    create_resp = client.post("/api/v1/categories/", json={"category_name": "Electronics"})
    cat_id = create_resp.json()["id"]
    response = client.delete(f"/api/v1/categories/{cat_id}")
    assert response.status_code == 204

def test_duplicate_category(client):
    client.post("/api/v1/categories/", json={"category_name": "Electronics"})
    response = client.post("/api/v1/categories/", json={"category_name": "Electronics"})
    assert response.status_code == 400
