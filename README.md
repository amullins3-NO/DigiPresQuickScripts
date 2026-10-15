# Digital Preservation Quick Scripts
The goals with Digital Preservation Quick Scripts is to create a repository of scripts archivists and digital preservationists can use natively on a variety of operating systems without installing additional software. While Powershell is the initial focus, the plan is to expand and create a suite of scripts for various operating systems to help archivists remain technologically agnostic without having to install software. 

Quick scripts that can be primarily run in powershell (windows) that perform various digital preservation actions.  Scripts in this repository will provide basic digital preservation metadata about file directories, as well as create basic metadata that can be used for processing and discovery. 

Most of these scripts were created in Powershell through careful searching of forums for pieces of code to use, then compiling them into a single script with prompts. Over time, some simple scripts evolved to include multiple functions. Some use of ChatGPT and other ML tools helped check for errors in the intial coding. 

We started using scripts to streamline and collapse various steps in our accessioning/processing workflows for born digital and digitized materials. Working with Powershell and CMD terminal allowed us to forgo any requests for specialized software installations. Most of the metadata they produce can be used to generate preliminary information and inventories of a directory and subdirectories, batch import digital objects in ArchivesSpace, and link to publicly accessible materials in either contentDM or Duracloud Preserve. While these scripts are purpose driven, they have been posted here to be as platform agnostic as possible. Eventually, I want to post versions of the scripts for bash and MACOS. 

Hopefully, these scripts can assist smaller archives or repositories work with their digital records backlog, especially those institutions or community organizations with limited staff, resources, and technical knowledge. Instructions for using the scripts will be geared towards this audience. 

# Powershell Scripts

Scripts can be run in Powershell by typing the following in the powershell terminal with the file path to the script file you want to run between the quotations:

powershell -executionpolicy -bypass "C:\path to script\script.ps1"

Press enter and the script will run. 


# CompleteFileScan.ps1
This is a comprehensive scan for understanding the contents of a directory and creating a comprehensive list of file types and quantities present on directory, preliminary inventories of specified file types, and a complete inventory of files on the directory that includes SHA256 checksum. The script helps complete steps for accessioning and processing digital records. 

# URL.ps1
This script creates a Duracloud Preserve url for each file in an identified directory. It produces a csv file including an inventory of files and their new urls. 

This script needs a simple edit for using it. The second line of the script has been marked with a # in front of $baseUrl, so that line will be ignored during the scan until the # is removed. Enter the base url for the your duracloud preserve space. Save the file.



