import requests
from bs4 import BeautifulSoup as Soup
from urllib.parse import urlparse, parse_qs

def extract_id_from_url(url):
    """
    Extracts the movie ID from a Netflix watch URL.

    Args:
        url (str): The full URL to a Netflix movie.

    Returns:
        str: The extracted movie ID.
    """
    parsed_url = urlparse(url)
    path_parts = parsed_url.path.split('/')
    # Typically, the ID is in the second part of the path if the path is like /watch/12345
    if len(path_parts) >= 3 and path_parts[1].lower() == 'watch':
        return path_parts[2]
    return None

def fetch_netflix_movie_details(netflix_url):
    """
    Fetches details from Netflix for a specified movie ID extracted from the provided URL.

    Args:
        netflix_url (str): URL to the Netflix movie page.

    Returns:
        tuple: A tuple containing title, year, date published, MPAA rating, duration,
               box art URL, description, and additional info such as genre, language,
               actor, and director info if available.
    """
    movie_id = extract_id_from_url(netflix_url)
    if not movie_id:
        return "Invalid Netflix URL"

    url = f"http://www.netflix.com/JSON/BOB?movieid={movie_id}"
    response = requests.get(url)
    movie_html = response.json().get("html", "")
    soup = Soup(movie_html, 'html.parser')
    
    def get_text_by_class(class_name):
        """ Helper to extract text by class, if exists. """
        element = soup.find(attrs={'class': class_name})
        return element.text.strip() if element else None

    def get_content_by_property(prop_name):
        """ Helper to extract content by property, if exists. """
        element = soup.find(attrs={'itemprop': prop_name})
        return element["content"] if element else None

    title = get_text_by_class('title')
    year = get_text_by_class('year')
    date_published = get_content_by_property('datePublished')
    mpaa_rating = get_text_by_class('mpaaRating')
    duration = get_text_by_class('duration')
    thumbnail_url = get_content_by_property('thumbnailUrl')

    description_element = soup.find(attrs={'class', 'boxShot'})
    description = description_element.nextSibling.strip() if description_element else None

    more_info = {detail.text.strip()[:-1].lower(): " ".join(info.text.strip().split())
                 for detail, info in zip(soup.findAll('dt'), soup.findAll('dd'))}

    return (title, year, date_published, mpaa_rating, duration, thumbnail_url, description, more_info)

# Example usage:
netflix_url = 'https://www.netflix.com/watch/81741396?source=35'
movie_details = fetch_netflix_movie_details(netflix_url)
print(movie_details)
