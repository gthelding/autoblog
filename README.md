# autoblog
## Goal
This will store the scripts I use to autopublish my obsidian posts to blog posts in my hugo SSG site. Thanks to [Network Chuck](https://www.youtube.com/watch?v=dnE7c0ELEH8) for the inspiration.

## My planned workflow is:
* Create an Obsidian note in a specific folder (e.g, "Posts")
* Trigger a bash script, which will:
  * Move any new Post notes from the Posts directory to the content/posts in my hugo site's directory
  * Call a python script (named imgproc.py for now) to analyze any .md files at the root of the posts directory. For each md file, it will:
      * make a new subdir for the post in the content/posts dir
      * Look for any embedded images and copy those images to the new subdir
      * convert the obsidian image "urls" to markdown-compatible links
      * look for an image that is embedded in the markdown file using the format [image.ext|cover], move that image to the subdir as cover.ext, and remove the reference to the image from the markdown file
      * look for an image that is embedded in the markdown file using the format [image.ext|thumbnail], move that image to the subdir as tumbnail.ext, and remove the reference to the image from the markdown file
      * move the file from content/posts to the new subdir, renaming it to index.md
  * call hugo to build the site locally
  * call rysnc to publish the site to my host (a VPS running apache in a docker container)
## Progress
A workable version of the python script is done.
## Next Steps
### Syncing Obsidian Post Notes to Hugo Content Dir
Network Chuck proposed using rsync to move files from the Obsidian dir to the Hugo content dir. Because I want to put the files into a subdirectory, I will need a different plan. I have existing posts and I also want to be able to add others by other means, so I don't want to blow away and recreate the content/posts data every time I add or change a post. Maybe I need to rysnc the posts to an intermediate directory and compare the files in the intermediate directory to their counterparts in the Hugo posts dir, updating them based on the dates they were last changed?

### Obsidian
* I'd like to make a template in Obsidian that automatically creates the front matter for a new blog post note.
* Adding captions to images from Obsidian to the hugo markdown file.
  
