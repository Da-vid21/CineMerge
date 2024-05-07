from supabase import create_client, Client
import os
from flask import Flask, request, jsonify
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

url = os.getenv("SUPABASE_URL")
key = os.getenv("SUPABASE_ANON_KEY")
supabase: Client = create_client(url, key)

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    email = data.get("email")
    password = data.get("password")

    # Look up the user in the Users table
    user = supabase.table("Users").select("*").eq("email", email).single() 


    if user is None:
        return jsonify({"error": "Invalid email or password"}), 401
    
    # Check if the password is correct
    if user["password"] != password:
        return jsonify({"error": "Invalid email or password"}), 401
    
    return jsonify({"message": "Login successful"})

@app.route("/getFolders", methods=["GET"])
def get_folders():
    # Get all the folders from the Folders table by the user's ID


    folders = supabase.table("Folders").select("*").execute()
    folder_data = folders.data  
    print(folder_data)

    return folder_data

@app.route("/addFolder", methods=["POST"])
def add_folder():
    data = request.get_json()
    print(data)
    # {'folderId': -1, 'folderTitle': 'New Horror Movies', 'created_at': '', 'folderColor': '#7c0200', 'totalHours': 0, 'userId': 1, 'folderGenre': 'Horror', 'folderIcon': 'https://hips.hearstapps.com/hmg-prod/images/horror-movies-1597961000.jpg?crop=0.502xw:1.00xh;0.498xw,0&resize=640:*'}
    folderTitle = data.get("folderTitle")
    folderGenre = data.get("folderGenre")
    folderColor = data.get("folderColor")
    folderIcon = data.get("folderIcon")
    userId = data.get("userId")
    totalHours = data.get("totalHours")

    folder = supabase.table("Folders").insert([{ "folderTitle": folderTitle, "folderGenre": folderGenre, "folderColor": folderColor, "folderIcon": folderIcon, "userId": userId, "totalHours": totalHours }]).execute()
    
    if folder.data:
        return jsonify({"message": "Folder added successfully"})
    
@app.route("/getMovies", methods=["GET"])
def get_movies():
    folderId = request.args.get("folderId")

    movies = supabase.table("Movies").select("*").eq("folderId", folderId).execute()
    movie_data = movies.data
    print(movie_data)
    return jsonify(movie_data)

@app.route("/addMovie", methods=["POST"])
def add_movie():
    data = request.get_json()
    print(data)
    # movieId, movieTitle, movieDescription, movieIcon, movieLink, folderId
    movieTitle = data.get("movieTitle")
    movieDescription = data.get("movieDescription")
    movieIcon = data.get("movieIcon")
    movieLink = data.get("movieLink")
    folderId = data.get("folderId")


    movie = supabase.table("Movies").insert([{ "movieTitle": movieTitle, "movieDescription": movieDescription, "movieIcon": movieIcon, "movieLink": movieLink, "folderId": folderId }]).execute()


    if movie.data:
        return jsonify({"message": "Movie added successfully"})
    
@app.route("/getMovieDetailed", methods=["GET"])
def get_movie_detailed():
    movieId = request.args.get("movieId")

    movie = supabase.table("Movies").select("*").eq("movieId", movieId).single().execute()
    print(movie)
    movie_data = movie.data
    return jsonify(movie_data)
    
    
if __name__ == "__main__":
    app.run(debug=True, port=5000)