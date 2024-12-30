import os
import re
import shutil

# Paths
posts_dir = "/home/greg/helding.net/content/posts/"
attachments_dir = "/home/greg/Documents/Obsidian Vaults/Peregrin/Greg/Files/"
static_images_dir = "/home/greg/helding.net/static/images/"

# Step 1: Process each markdown file in the posts directory
for filename in os.listdir(posts_dir):
    if filename.endswith(".md"):
        filepath = os.path.join(posts_dir, filename)
        
        with open(filepath, "r") as file:
            content = file.read()
        
        # Step 2: Make a new directory for the post and its images 
        # Replace spaces with dashes in filename and remove the file extension
        filename_fixed = filename.replace(" ", "-")
        dirname = os.path.splitext(filename_fixed)[0]
        post_dir = os.path.join(posts_dir, dirname)
        if not os.path.exists(post_dir):
            os.mkdir(post_dir)

        # Step 3: Find and format image links and copy images to post_dir
        # Find all image links in the format ![Image Description](/images/Pasted%20image%20...%20.png, etc)
        images = re.findall(r'!\[\[([^]]*\.(?:png|jpg|jpeg|gif|webp))\]\]', content)

        # Replace image links; ensure URLs are correctly formatted; remove cover image and thumbnail image links
        for image in images:
            # Prepare the Markdown-compatible link with %20 replacing spaces
            markdown_image = f"![Image Description]({image.replace(' ', '%20')})"
            content = content.replace(f"![[{image}]]", markdown_image)
            # Copy the image to the post_dir
            image_source = os.path.join(attachments_dir, image)
            if os.path.exists(image_source):
                shutil.copy(image_source, post_dir)

        #Step 4: Find cover image link, remove link, and copy image to post_dir
        cover_image = re.findall(r'!\[\[([^]]*\.(?:png|jpg|jpeg|gif|webp))\|cover\]\]', content)
        for image in cover_image:
            # Replace the cover image link with an empty string
            content = re.sub(f"^!\\[\\[{image}\\|cover\\]\\]\\n", "", content, flags=re.MULTILINE)
            # Copy the image to the post_dir
            new_filename = f"cover.{image.split('.')[-1]}"
            new_filepath = os.path.join(post_dir, new_filename)
            image_source = os.path.join(attachments_dir, image)
            if os.path.exists(image_source):
                shutil.copy(image_source, new_filepath)

        #Step 5: Find thumbnail image link, remove link, and copy image to post_dir
        thumbnail_image = re.findall(r'!\[\[([^]]*\.(?:png|jpg|jpeg|gif|webp))\|thumbnail\]\]', content)
        for image in thumbnail_image:
            # Replace the thumbnail image link with an empty string
            content = re.sub(f"^!\\[\\[{image}\\|thumbnail\\]\\]\\n", "", content, flags=re.MULTILINE)
            # Copy the image to the post_dir
            new_filename = f"thumbnail.{image.split('.')[-1]}"
            new_filepath = os.path.join(post_dir, new_filename)
            image_source = os.path.join(attachments_dir, image)
            if os.path.exists(image_source):
                shutil.copy(image_source, new_filepath)

        # Step 6: Write the updated content back to the markdown file
        with open(filepath, "w") as file:
            file.write(content)
       
        # Step 7: Move the markdown file to a file named index.md in the post_dir
        new_filepath = os.path.join(post_dir, "index.md")
        shutil.move(filepath, new_filepath)

print("Markdown files processed and images and markdown files copied successfully.")

