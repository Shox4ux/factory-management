def create_category_and_factory(client):
    cat_resp = client.post("/api/v1/categories/", json={"category_name": "Electronics"})
    cat_id = cat_resp.json()["id"]
    fac_resp = client.post("/api/v1/factories/", json={"name": "Test Factory", "factory_category_id": cat_id})
    return fac_resp.json()["id"]

def test_create_product(client):
    fac_id = create_category_and_factory(client)
    response = client.post("/api/v1/products/", json={"name": "Widget", "factory_id": fac_id})
    assert response.status_code == 201
    assert response.json()["name"] == "Widget"

def test_list_products(client):
    fac_id = create_category_and_factory(client)
    client.post("/api/v1/products/", json={"name": "Widget", "factory_id": fac_id})
    response = client.get("/api/v1/products/")
    assert response.status_code == 200

def test_update_product(client):
    fac_id = create_category_and_factory(client)
    create_resp = client.post("/api/v1/products/", json={"name": "Widget", "factory_id": fac_id})
    prod_id = create_resp.json()["id"]
    response = client.put(f"/api/v1/products/{prod_id}", json={"name": "Updated Widget"})
    assert response.status_code == 200
    assert response.json()["name"] == "Updated Widget"

def test_delete_product(client):
    fac_id = create_category_and_factory(client)
    create_resp = client.post("/api/v1/products/", json={"name": "Widget", "factory_id": fac_id})
    prod_id = create_resp.json()["id"]
    response = client.delete(f"/api/v1/products/{prod_id}")
    assert response.status_code == 204
