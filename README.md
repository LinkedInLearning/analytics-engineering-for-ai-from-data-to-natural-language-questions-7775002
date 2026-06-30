# Analytics Engineering for AI: From Data to Natural-Language Questions
This is the repository for the LinkedIn Learning course `Analytics Engineering for AI: From Data to Natural-Language Questions`. The full course is available from [LinkedIn Learning][lil-course-url].

![lil-thumbnail-url]

## Course Description

_See the readme file in the main branch for updated instructions and information._

As organizations adopt AI-driven analytics, the quality and structure of analytical data become critical to delivering reliable, business-ready insights. This course walks through an end-to-end analytics engineering workflow that enables natural-language analytics on top of trusted data models. Learn how to ingest a realistic dataset, model clean fact and dimension tables in a warehouse, and add tests and documentation to establish trust. Get introduced to a semantic layer that defines consistent business metrics and dimensions. Throughout the course, take note of the emphasis on clarity, trust, and reproducibility, not just tool-specific shortcuts. Finally, connect a lightweight AI text-to-SQL interface and demonstrate how business users can ask natural-language questions and receive accurate, governed answers without writing SQL.

## Learning Objectives
- Gather and load a small, realistic dataset into a local warehouse.
- Define and model clean analytics tables in the warehouse (facts and dimensions).
- Add tests and documentation to ensure models are trustworthy.
- Build a semantic layer with clear business metrics and dimensions on top of the models.
- Connect a lightweight AI/text-to-SQL layer that can query the semantic layer.
- Posit natural-language questions and receive consistent answers without writing any SQL.
  
## Instructions
This repository has branches for each of the videos in the course. You can use the branch pop up menu in github to switch to a specific branch and take a look at the course at that stage, or you can add `/tree/BRANCH_NAME` to the URL to go to the branch you want to access.

## Branches
The branches are structured to correspond to the videos in the course. The naming convention is `CHAPTER#_MOVIE#`. As an example, the branch named `02_03` corresponds to the second chapter and the third video in that chapter. 
Some branches will have a beginning and an end state. These are marked with the letters `b` for "beginning" and `e` for "end". The `b` branch contains the code as it is at the beginning of the movie. The `e` branch contains the code as it is at the end of the movie. The `main` branch holds the final state of the code when in the course.

When switching from one exercise files branch to the next after making changes to the files, you may get a message like this:

    error: Your local changes to the following files would be overwritten by checkout:        [files]
    Please commit your changes or stash them before you switch branches.
    Aborting

To resolve this issue:
	
    Add changes to git using this command: git add .
	Commit changes using this command: git commit -m "some message"

## Installing
1. To use these exercise files, you must have the following installed:
	- [list of requirements for course]
2. Clone this repository into your local machine using the terminal (Mac), CMD (Windows), or a GUI tool like SourceTree.
3. [Course-specific instructions]

## Instructor

José Siles

Data Engineer at Nestle

[lil-course-url]: https://www.linkedin.com/learning/analytics-engineering-for-ai-from-data-to-natural-language-questions/build-an-end-to-end-ai-data-pipeline?u=104
[lil-thumbnail-url]: https://media.licdn.com/dms/image/v2/D560DAQG6mI4G0uXcRQ/learning-public-crop_675_1200/B56Z6RYyCLKwAY-/0/1780555653917?e=2147483647&v=beta&t=DPamDEU1oyqvk3wPXA2tAEc-bd0UaM5VVP8abRMab14

