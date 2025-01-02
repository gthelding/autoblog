<%*
let fileName = tp.file.title;
if (fileName.startsWith("Untitled")) {
    fileName = await tp.system.prompt("Enter file name:");
    await tp.file.rename(fileName);
}
let category = await tp.system.prompt("Enter a category for the post:")
let tagInput = await tp.system.prompt("Enter tags (comma-separated):")
let summary = await tp.system.prompt("Enter a short summary:")
let tags = tagInput.split(',').map(tag => tag.trim()).filter(tag => tag)
-%>
---
title: <% fileName %>
date: <% tp.file.creation_date("YYYY-MM-DD") %>
draft: false
tags:
<%tags.map(tag => `  - ${tag}`).join('\n') %>
categories:
  - <% category %>
summary: <% summary %>
---
`Enter a cover image thusly: ![[Image_File.ext|cover]]`
`Enter a thumbnale image thusly: ![[Image_File.ext|thumbnail]]`
## Heading One
Post text
