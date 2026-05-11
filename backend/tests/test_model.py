def create_chain(client):
    cat_resp = client.post("/api/v1/categories/", json={"category_name": "Electronics"})
    cat_id = cat_resp.json()["id"]
    fac_resp = client.post("/api/v1/factories/", json={"name": "Test Factory", "factory_category_id": cat_id})
    fac_id = fac_resp.json()["id"]
    prod_resp = client.post("/api/v1/products/", json={"name": "Widget", "factory_id": fac_id})
    return prod_resp.json()["id"]

def test_create_model(client):
    prod_id = create_chain(client)
    response = client.post("/api/v1/models/", json={"name": "Model A", "price": "99.99", "info": "Details", "product_id": prod_id})
    assert response.status_code == 201
    assert response.json()["name"] == "Model A"

def test_list_models(client):
    prod_id = create_chain(client)
    client.post("/api/v1/models/", json={"name": "Model A", "price": "99.99", "info": "Details", "product_id": prod_id})
    response = client.get("/api/v1/models/")
    assert response.status_code == 200

def test_update_model(client):
    prod_id = create_chain(client)
    create_resp = client.post("/api/v1/models/", json={"name": "Model A", "price": "99.99", "info": "Details", "product_id": prod_id})
    model_id = create_resp.json()["id"]
    response = client.put(f"/api/v1/models/{model_id}", json={"name": "Model B"})
    assert response.status_code == 200
    assert response.json()["name"] == "Model B"

def test_delete_model(client):
    prod_id = create_chain(client)
    create_resp = client.post("/api/v1/models/", json={"name": "Model A", "price": "99.99", "info": "Details", "product_id": prod_id})
    model_id = create_resp.json()["id"]
    response = client.delete(f"/api/v1/models/{model_id}")
    assert response.status_code == 204
