#!/usr/bin/env python3
# -*-: coding utf-8 -*-
"""
Script for editing skills to work properly using regex
"""
import re
from skills_to_edit import PATH_TO_SKILLS, SKILLS

def write_file(file_name, string):
    """
    Write string to file
    """
    with open(file_name, "w") as fh:
        return fh.write(string)

def read_file(file_name):
    """
    Read content from file
    """
    with open(file_name, "r") as fh:
        return fh.read()


def regex_on_string(find, replace, string):
    """
    Do regex find replace on a file
    """
    return re.sub(find, replace, string,  flags=re.DOTALL)

def edit_skill(skill):
    """
    Edit files for a skill
    """
    for file_tuple in skill:
        file_name = PATH_TO_SKILLS + file_tuple[0]
        try:
            file_content = read_file(file_name)
        except FileNotFoundError:
            print("File not found: ", file_name)
            continue

        edited_file_content = regex_on_string(file_tuple[1][0], file_tuple[1][1], file_content)
        write_file(file_name, edited_file_content)

if __name__ == "__main__":
    for skill in SKILLS.values():
        edit_skill(skill)
