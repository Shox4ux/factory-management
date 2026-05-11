import pytest

def create_category(client):
    resp = client.post("/api/v1/categories/", json={"category_name": "Electronics"})
    return resp.json()["id"]

def test_create_factory(client):
    cat_id = create_category(client)
    response = client.post("/api/v1/factories/", json={"name": "Test Factory", "factory_category_id": cat_id})
    assert response.status_code == 201
    data = response.json()
    assert data["name"] == "Test Factory"

def test_list_factories(client):
    cat_id = create_category(client)
    client.post("/api/v1/factories/", json={"name": "Factory A", "factory_category_id": cat_id})
    response = client.get("/api/v1/factories/")
    assert response.status_code == 200
    assert len(response.json()) >= 1

def test_search_factory_by_name(client):
    cat_id = create_category(client)
    client.post("/api/v1/factories/", json={"name": "Unique Name XYZ", "factory_category_id": cat_id})
    response = client.get("/api/v1/factories/?name=Unique")
    assert response.status_code == 200
    assert any("Unique" in f["name"] for f in response.json())

def test_get_factory(client):
    cat_id = create_category(client)
    create_resp = client.post("/api/v1/factories/", json={"name": "Factory B", "factory_category_id": cat_id})
    fac_id = create_resp.json()["id"]
    response = client.get(f"/api/v1/factories/{fac_id}")
    assert response.status_code == 200

def test_update_factory(client):
    cat_id = create_category(client)
    create_resp = client.post("/api/v1/factories/", json={"name": "Old Name", "factory_category_id": cat_id})
    fac_id = create_resp.json()["id"]
    response = client.put(f"/api/v1/factories/{fac_id}", json={"name": "New Name"})
    assert response.status_code == 200
    assert response.json()["name"] == "New Name"

def test_delete_factory(client):
    cat_id = create_category(client)
    create_resp = client.post("/api/v1/factories/", json={"name": "To Delete", "factory_category_id": cat_id})
    fac_id = create_resp.json()["id"]
    response = client.delete(f"/api/v1/factories/{fac_id}")
    assert response.status_code == 204
