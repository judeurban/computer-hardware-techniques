import os
import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin

# URL of the webpage
page_url = "https://people.duke.edu/~nts9/logicgates/"
# page_url = urljoin(base_url, "index.html")

# Create a directory to save the files
output_dir = "hdl_files"
os.makedirs(output_dir, exist_ok=True)

# Fetch the webpage content
response = requests.get(page_url)
if response.status_code == 200:

    soup = BeautifulSoup(response.text, "html.parser")
    links = soup.find_all("a")

    for link in links:

        link_url = urljoin(page_url, link["href"])
        if link_url.endswith(".hdl"):
            file_name = os.path.basename(link_url)
            output_path = os.path.join(output_dir, file_name)

            # Fetch the content of the link
            file_content = requests.get(link_url).text

            # Save the content to the output file
            with open(output_path, "w") as f:
                f.write(file_content)

            print(f"Saved {file_name}")

    print("All .hdl files saved.")
else:
    print("Failed to fetch the webpage.")
