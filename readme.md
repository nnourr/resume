# JSON TeX Resume

This project abstracts LaTeX resume creation into JSON configuration definitions. 

## Template

The resume template is defined through generic `.tex` components in the [components folder](./src/components/). These are used as the building blocks for the candidate's final resume. The components are meant to use minimal static values and rely on LaTeX variable definitions to populate the resume sections. These variable values are defined in our JSON configs. 

## JSON Configuration

Most LaTeX components are not self sufficient and will not compile without their variable definitions. The definitions are housed in JSON files in the [config folder](./config/). The field names follow the required variable uses in the LaTeX template, and the values defined are reflected in the final PDF. 

The resume sections are defined in the [sections.json](./config/sections.json) file and needs to follow this format:

```json
[
    {
        "sectionName": "Experience",
        "subheadings": [
            {
                "company": "No Name Legacy Software Inc.",
                "period": "May 2023 - Next Layoff Round",
                "position": "Internal Tools Developer",
                "location": "localhost",
                "techstack": "C, COBOL",
                "resumeItems": [
                    "Did this and that",
                    "Achieved this and that"
                ]
            },
            ...
        ]
    },
    ...
]
```

If any of the fields are not required, they need to be defined and can be kept empty. 

[heading.json](./config/heading.json) is kept separate to define the candidate's information separate from the rest of the content. Following format is required:

```json
{
    "candidateFirstName": "Raging",
    "candidateLastName": "Chipmunk",
    "candidateAddress": "Non Doxable Address",
    "candidatePhone": "+1 (123) 456-7812",
    "candidateEmail": "email@personal.com",
    "linkedin": "linkedin",
    "github": "github",
    "portfolio": "portfolio.me"
}
```
## Python Script

[generate_resume.py](./src/generate_resume.py) is the main script that glues all the components and their respective configurations together. It iterates over the configuration files, translates them into variable definitions in LaTeX, and adds all the components to one single file called `resume.tex`. 

## Create Your Resume

### Pre-requisites
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### Steps

1. Populate [JSON configs as defined above](#json-configuration).
2. Run `docker compose up`.
3. Find `resume.pdf` in a newly created `out` folder.

## License

MIT License.