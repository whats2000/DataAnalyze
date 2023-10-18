import pandas as pd
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException, NoSuchElementException

def scrape_spotrac_nhl_rankings(year):
    # Initialize the Selenium webdriver
    driver = webdriver.Chrome()

    try:
        # Construct the URL based on the specified year
        url = f"https://www.spotrac.com/nhl/rankings/{year}"

        # Navigate to the URL
        driver.get(url)

        # Wait for the table to load (you may need to adjust the timeout)
        WebDriverWait(driver, 10).until(EC.presence_of_element_located((By.CLASS_NAME, 'datatable')))

        # Find the table with the specified class
        try:
            table = driver.find_element(By.CLASS_NAME, 'datatable')

            # Extract data from the table
            rows = table.find_elements(By.TAG_NAME, 'tr')
            data = []

            for row in rows:
                data_cells = row.find_elements(By.TAG_NAME, 'td')
                if data_cells:
                    data.append([cell.text.strip() for cell in data_cells])

            # Assuming the first row is the header
            header_cells = rows[0].find_elements(By.TAG_NAME, 'th')
            headers = [cell.text.strip() for cell in header_cells]

            # Create a pandas DataFrame
            df = pd.DataFrame(data, columns=headers)

            # Close the WebDriver
            driver.quit()

            return df

        except NoSuchElementException:
            print("Table with the specified class not found on the page.")
            return None

    except TimeoutException:
        print("Timed out waiting for the page to load.")
        driver.quit()
        return None

# Example usage:
year_to_scrape = 2024  # Replace with the desired year
data_frame = scrape_spotrac_nhl_rankings(year_to_scrape)

if data_frame is not None:
    print(data_frame)