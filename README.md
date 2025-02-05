# Autoblog

Transform your Obsidian notes into a Hugo-powered blog automatically. This project provides scripts to seamlessly publish your Obsidian notes as blog posts using Hugo static site generator. I use this tool to autopublish my [Obsidian](https://obsidian.md) posts to blog posts in my [Hugo](https://gohugo.io) SSG site.

## Features

**Automated Publishing Pipeline**
- Converts Obsidian notes to Hugo-compatible blog posts
- Handles image processing and organization
- Manages cover and thumbnail images
- Maintains proper directory structure
- Automates git operations and deployment

**Smart Image Management**
- Processes embedded images with special tags (cover, thumbnail)
- Creates organized subdirectories for each post
- Converts Obsidian image links to markdown format
- Handles image copying and relocation

## Workflow
* Create an Obsidian note in a specific folder (e.g., "Posts" using Template "Blog Post Template.md")
* Run a bash script (updateblog.sh), which:
  * Moves any new Post notes from the Posts directory to the content/posts in my HUGO site's directory
  * Calls a python script (imgproc.py) to analyze any .md files at the root of the posts directory. For each md file, it:
      * Makes a new subdir for the post in the content/posts dir
      * Looks for any embedded images and copy those images to the new subdir
      * Converts the obsidian image "urls" to markdown-compatible links
      * Looks for an image that is embedded in the markdown file using the format [image.ext|cover], move that image to the subdir as cover.ext, and remove the reference to the image from the markdown file
      * Looks for an image that is embedded in the markdown file using the format [image.ext|thumbnail], move that image to the subdir as tumbnail.ext, and remove the reference to the image from the markdown file
      * Moves the file from content/posts to the new subdir, renaming it to index.md
  * Calls hugo to build the site locally
  * Uses git to commit and push changes to (in my case, a private) github repo for the site (This repo just stores a copy of the HUGO project. Some may want to deploy the site using git. I have a VPS webserver for that.)
  * Call rysnc to publish the site to webserver (in my case, a VPS running apache in a docker container)
  
## Flow Chart of the Process
```mermaid
graph TD
a1([New Note])
a2[(Obsidian Posts Folder)]
a3[(Obsidian Images Folder)]
subdir@{ shape: subproc, label: "Make subdir for New Post" }
extract@{ shape: subproc, label: "Process Image Links" }
copy@{ shape: subproc, label: "Copy Images" }
hugo[(Hugo Project)]
note@{ shape: doc, label: "New Post" }
modpost@{ shape: doc, label: "Modified Post" }
rsync[rsync]
a2-->rsync
rsync-->note
a3-->copy
note-->extract
build@{ shape: process, label: "Build Hugo Site Including New Post Subdir" }
git@{ shape: process, label: "Commit and Push Hugo Project to Private GitHub" }
mygh[(My GitHub)]
vps(((Webserver)))
pub@{ shape: process, label: "Rsync to Web Server" }
subgraph draft [Draft New Note in Obsidian]
a1-->|Markdown File|a2
a1-->|Images|a3
end
subgraph python [Python Script]
note-->subdir
subdir-->hugo
extract-->copy
extract-->modpost
copy-->|Copy to Subdir|hugo
modpost-->|move to Subdir|hugo
end
hugo-->publish
subgraph publish [Generate and Publish]
build-->git
git-->mygh
git-->pub
pub-->vps
end
```
## Obsidian
* I use a template ([Blog Post Template.md](https://healthcarenetwork.org/)) in Obsidian that automatically creates the front matter for a new blog post note by prompting the user when a new note is made using the template. The Template requires the Templater Plugin. Whenever I make a new note in the Posts Folder, it uses this template.

## Future Plans
* Adding captions to images from Obsidian to the hugo markdown file.

## Acknowledgments

Inspired by NetworkChuck's blog [pipeline](https://www.youtube.com/watch?v=dnE7c0ELEH8) concept.

