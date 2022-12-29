# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By

def get_current_end_point(url: str) -> str:
    return url.split("/")[-1]

def login (driver, user, password):
    """
    Start the login with standard_user.
    """
    print(f"[*] Login in as {user}")
    driver.find_element(By.ID, 'user-name').send_keys(user)
    driver.find_element(By.ID, 'password').send_keys(password)
    driver.find_element(By.ID, 'login-button').click()
    assert get_current_end_point(driver.current_url) == "inventory.html"

def add_items(driver):
    """
    Add 6 items to the cart.
    """
    assert get_current_end_point(driver.current_url) == "inventory.html"
    print(f"[*] Adding items to cart.")
    inventory_list = driver.find_elements(By.CLASS_NAME, "inventory_item")
    for item in inventory_list:
        item_text = item.find_element(By.CLASS_NAME, 'inventory_item_name').text
        print(f"\t- {item_text} was added.")
        item.find_element(By.CLASS_NAME, 'btn_inventory').click()
    items_count = driver.find_element(By.CLASS_NAME, "shopping_cart_badge").text
    assert int(items_count) == 6
    driver.find_element(By.CLASS_NAME, "shopping_cart_link").click()
    assert get_current_end_point(driver.current_url) == "cart.html"

def remove_items(driver):
    """
    Remove added items from cart.
    """
    assert get_current_end_point(driver.current_url) == "cart.html"
    print(f"[*] Removing items to cart.")
    cart_list = driver.find_elements(By.CLASS_NAME, "cart_item")
    for item in cart_list:
        item_text = item.find_element(By.CLASS_NAME, 'inventory_item_name').text
        print(f"\t- {item_text} was removed.")
        item.find_element(By.CLASS_NAME, 'cart_button').click()
    items_count = len(driver.find_elements(By.CLASS_NAME, "cart_item"))
    assert int(items_count) == 0
    print(f"[✓] All items were removed successfully.")

    driver.find_element(By.CLASS_NAME, "shopping_cart_link").click()

if __name__ == "__main__":
    print ('Starting the browser...')
    options = ChromeOptions()
    options.add_argument("--no-sandbox") 
    options.add_argument("--disable-dev-shm-usage") 
    options.add_argument("--headless") 
    options.add_argument("start-maximized")
    options.add_argument("disable-infobars")
    options.add_argument("--disable-extensions")
    options.add_argument("--disable-gpu")

    driver = webdriver.Chrome(options=options)
    print ('Browser started successfully. Navigating to the demo page to login.')
    driver.get('https://www.saucedemo.com/')
    login(driver, 'standard_user', 'secret_sauce')
    add_items(driver)
    remove_items(driver)
    print("[✓] All tests ran successfully.")
