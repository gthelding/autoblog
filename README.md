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
Network Chuck proposed using rsync to move files from the Obsidian dir to the Hugo content dir. As long as I assume Obsidian is the source of truth for the posts created there, then I can use rysnc. It will just move over all the posts and convert them. If they have been updated, they will update (because the python script will overwrite the files). If they are the same, nothing changes except the time stamps, but that doens't matter because the blog posts are dated in their front matter. I can still add posts manually and this setup will ignore them (in that it never will see them. The only thing I need to be careful of is not to name two posts the same.

### Obsidian
* I'd like to make a template in Obsidian that automatically creates the front matter for a new blog post note.
* Adding captions to images from Obsidian to the hugo markdown file.
  
