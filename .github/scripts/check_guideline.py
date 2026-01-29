#!/usr/bin/env python3

##############################################################################
## Copyright (C) 2022-2023, 2026 Analog Devices, Inc. All rights reserved.
### SPDX short identifier: ADIBSD
#
## Check readme_check_guideline.md from the same folder, for more details.
##############################################################################

import os
import re
import codecs
import sys
from datetime import datetime

##############################################################################
#
# Class definitions
##############################################################################
class Port (object):
    def __init__ (self, name="unknown", direction="unknown", ptype="wire"):
        self.name = name
        self.direction = direction
        self.ptype = ptype


class Occurrence (object):
    # path - to the file where the occurrence was found
    # line - where the instantiated module is
    # line_end - where the instantiated module ends
    # pos_start_ports - how many lines after .line the ports list starts, inside
    #                   the instantiated module
    def __init__ (self, path="unknown", line="unknown"):
        self.path = path
        self.line = line
        self.line_end = -1
        self.pos_start_ports = -1


class Interface (object):
    def __init__ (self):
        self.interface = []

    def add_port (self, port):
        self.interface.append(port)


##############################################################################
#
# Functions
##############################################################################
def is_comment (line):
    rcoma = re.compile(r'^\s*//')
    rcomb = re.compile(r'^\s*/\*')
    if (rcoma.match(line) or rcomb.match(line)):
        return True
    else:
        return False

def is_multiline_comment (line):
    if ((line.strip()).startswith("*")):
        return True
    else:
        if ((line.find("/*") != -1) or (line.find("*/") != -1)):
            return True
        else:
            return False

def is_cmt(line):
    return is_comment(line) or is_multiline_comment(line)

def is_paramdef (line):
    rparameter = re.compile(r'^\s*parameter\s.*')
    if (rparameter.match(line)):
        return True
    else:
        return False

def is_iodef (line):
    rinput = re.compile(r'^\s*input\s.*')
    routput= re.compile(r'^\s*output\s.*')
    rinout = re.compile(r'^\s*inout\s.*')
    if ((rinput.match(line)) or (routput.match(line)) or (rinout.match(line))):
        return True
    else:
        return False

# check if the given string is made only of spaces or tabs
def only_spaces_or_tabs (substr):
    substr = substr.strip()
    substr = substr.strip("\t")
    if (substr == ""):
        return True
    else:
        return False


# check if one of the modified files appears in the warning message
def list_has_substring (modified_files, message):
    for mfile in modified_files:
        if (message.find(mfile) != -1):
            return True

    return False


# check if file is between the modified files specified as arguments
def string_in_list (module_path, modified_files):
    for mfile_path in modified_files:
        if (("./" + mfile_path) == module_path or mfile_path == module_path):
            return True

    return False


# write lines to file
def rewrite_file(path, lines):
    with open(path, "w") as f:
        for line in lines:
            f.write(line.rstrip() + "\n")


# get the indentation of a line
def indent_of(s: str) -> int:
    return len(s) - len(s.lstrip())


# return an even indentation width, at least base_min.
def even_indent(n: int, base_min: int = 2) -> int:
    n2 = max(base_min, n)
    return n2 if (n2 % 2 == 0) else (n2 + 1)


# split line into code and comment parts, return tuple (code, comment)
def split_code_comment_sl(raw: str):
    code, sep, cmt = raw.rstrip("\n").partition("//")
    return code.rstrip(), (sep + cmt).rstrip() if sep else ""


# append formatted warning for a specific line to the list
def emit_line_warning(lw, path, base_line_nb, start_idx, abs_idx, msg: str):
    real_ln = base_line_nb + (abs_idx - start_idx)
    lw.append(f"{path} : {real_ln} {msg}")


# find the line index where a statement ends (with ';'), starting from start_i
def stmt_end_line(lines, start_i: int) -> int:
    depth = 0
    in_block = False
    in_line = False
    for j in range(start_i, len(lines)):
        s = lines[j]
        i = 0
        while i < len(s):
            ch = s[i]
            nxt = s[i+1] if i+1 < len(s) else ""
            if in_line:
                break
            if in_block:
                if ch == "*" and nxt == "/":
                     in_block = False
                     i += 2
                     continue
                i += 1
                continue
            if ch == "/" and nxt == "/":
                 in_line = True
                 i += 2
                 continue
            if ch == "/" and nxt == "*":
                 in_block = True
                 i += 2
                 continue
            if ch in "([{":
                depth += 1
            elif ch in ")]}":
                depth = max(0, depth - 1)
            elif ch == ";" and depth == 0:
                return j
            i += 1
    return -1


# split a text by top-level commas (not inside (), [], {}, nor in comments)
def split_top_level_commas(text: str):
    parts, buf = [], []
    depth = 0
    in_block = False
    in_line = False
    i = 0
    L = len(text)
    while i < L:
        ch = text[i]
        nxt = text[i+1] if i+1 < L else ""
        if in_line:
            buf.append(ch)
            if ch == "\n": in_line = False
            i += 1
            continue
        if in_block:
            buf.append(ch)
            if ch == "*" and nxt == "/":
                 buf.append("/")
                 i += 2
                 continue
            i += 1
            continue
        if ch == "/" and nxt == "/":
             in_line = True
             buf.append("//")
             i += 2
             continue
        if ch == "/" and nxt == "*":
             in_block = True
             buf.append("/*")
             i += 2
             continue
        if ch in "([{":
             depth += 1
             buf.append(ch)
             i += 1
             continue
        if ch in ")]}":
             depth = max(0, depth - 1)
             buf.append(ch)
             i += 1
             continue
        if ch == "," and depth == 0:
            parts.append("".join(buf))
            buf = []
            i += 1
            continue
        buf.append(ch)
        i += 1
    parts.append("".join(buf))
    return parts


# strip trailing ';' or ',' and spaces
def strip_trailing_semicol(line: str) -> str:
    return re.sub(r"[;,]\s*$", "", line.rstrip())


# normalize string
def normalize_str(s: str) -> str:
    # compress spaces, normalize '-'
    s = re.sub(r"[ \t]+", " ", s.strip())
    s = re.sub(r"\s*-\s*", "-", s)
    # remove ",,"
    s = re.sub(r",\s*,+", ",", s)
    s = strip_trailing_semicol(s)
    s = re.sub(r"\.\s*$", "", s)
    # apply canonical ", "
    s = re.sub(r",\s*", ", ", s)
    return s


# find the span of the top-level {...} block (not in comments)
def find_top_level_brace_span(lines, start_i: int, end_i: int):
    depth = 0
    in_block = False
    in_line = False
    open_pos = None
    for j in range(start_i, end_i + 1):
        s = lines[j]
        i = 0
        L = len(s)
        while i < L:
            ch = s[i]
            nxt = s[i+1] if i+1 < L else ""
            if in_line:
                break
            if in_block:
                if ch == "*" and nxt == "/":
                    in_block = False
                    i += 2
                    continue
                i += 1
                continue
            if ch == "/" and nxt == "/":
                in_line = True
                i += 2
                continue
            if ch == "/" and nxt == "*":
                in_block = True
                i += 2
                continue
            if ch == "{" and depth == 0:
                open_pos = (j, i)
                depth = 1
                i += 1
                continue
            if ch == "{" and depth > 0:
                depth += 1
                i += 1
                continue
            if ch == "}":
                depth = max(0, depth - 1)
                if depth == 0 and open_pos is not None:
                    return open_pos + (j, i)
                i += 1
                continue
            if ch in "([<":
                depth += 1
            elif ch in ")]>":
                depth = max(0, depth - 1)
            i += 1
    return None


# extract text between {...} from lines[open_l][open_c] to lines[close_l][close_c]
def extract_between_braces(lines, open_l, open_c, close_l, close_c) -> str:
    # strictly between '{' and '}' (excluding '}'/';' or any text after)
    if open_l == close_l:
        return lines[open_l][open_c+1:close_c]
    chunks = [lines[open_l][open_c+1:]]

    if close_l - open_l > 1:
        chunks.extend(lines[open_l+1:close_l])
    chunks.append(lines[close_l][:close_c])

    return "".join(chunks)


# replace lines[start_idx:end_idx+1] with new_block_lines, return original span
def replace_block_atomic(lines, start_idx, end_idx, new_block_lines):
    orig_span = lines[start_idx:end_idx+1]
    del lines[start_idx:end_idx+1]
    for ln in reversed(new_block_lines):
        lines.insert(start_idx, ln)
    return orig_span


###############################################################################
#
# Check if file has correct properties, meaning that the file extension has to
# be .v or .sv  and it should not be some certain file (tb)
# Returns true or false.
###############################################################################
def check_hdl_filename(filename):

    if not (filename.endswith(".v") or filename.endswith(".sv")):
        return False
    if (filename.find("tb") != -1):
        return False

    return True


###############################################################################
#
# Detect all HDL files (.v, .sv) present in the given directory in /library and
# /projects.
# Return a list with the relative paths.
###############################################################################
def detect_all_hdl_files (directory):

    detected_files = []
    for folder, dirs, files in os.walk(directory):
        ## folder name must be either library or projects,
        ## and it must not contain a dot in the name (Vivado generated)
        if ((folder[1:-2]).find(".") == -1
            and (folder.find("library") != -1 or folder.find("projects") != -1)):

            for file in files:
                #filename_wout_ext = (os.path.splitext(file)[0])
                if (check_hdl_filename(file)):
                    fullpath = os.path.join(folder, file)
                    detected_files.append(fullpath)

    return detected_files


###############################################################################
#
# Detect the kind of file unit (package, module).
# Return the string containing the type of file unit, or None if not found.
###############################################################################
def detect_file_unit_(path: str):

    with open(path, "r") as f:
        in_block = False
        for raw in f:
            line = raw.strip()
            if in_block:
                if "*/" in line:
                    line = line.split("*/", 1)[1].strip()
                    in_block = False
                else:
                    continue
            if not line:
                continue
            if line.startswith("/*"):
                if "*/" in line:
                    line = line.split("*/", 1)[1].strip()
                    if not line:
                        continue
                else:
                    in_block = True
                    continue
            if line.startswith("//") or line.startswith("`"):
                continue
            if line.startswith("package "):
                return "package"
            if line.startswith("module "):
                return "module"

    return None


###############################################################################
#
# Determine the file name from the fullpath.
# Return the string containing the file name without extension.
###############################################################################
def get_file_name (file_path):

    # split the path using the / and take the last group, which is the file.ext
    split_path = file_path.split("/")
    filename = split_path[len(split_path) - 1]

    # take the module name from the filename with the extension
    filename_wout_ext = filename.split(".")[0]

    return filename_wout_ext


###############################################################################
#
# Check if there are lines after `endmodule or `endpackage and two consecutive
# empty lines, and if there are and edit_files is true, delete them.
###############################################################################
def check_extra_lines (module_path, list_of_lines, lw, edit_files, end_token="endmodule"):

    # Remove empty lines at the beggining of the file
    if list_of_lines and list_of_lines[0].strip() == "":
        lw.append(f"{module_path} : empty line at beginning of file")
        if edit_files:
            while list_of_lines and list_of_lines[0].strip() == "":
                list_of_lines.pop(0)

    passed_end = False
    line_nb = 1
    prev_line = ""
    remove_end_lines = False
    add_end_line = False

    if (edit_files):
        remove_extra_lines = False

    for line in list_of_lines:
        # GC: detect the closing token (end_token) in order to flag content after it
        if (line.find(end_token) != -1):
            passed_end = True

        # if we passed the closing token
        if (passed_end and (line.find(end_token) == -1)):
            remove_end_lines = True

        # GC: check for empty lines
        if (line_nb >= 2):
            if (only_spaces_or_tabs(prev_line) and only_spaces_or_tabs(line)
                and (not is_comment(prev_line)) and (not is_comment(line))):

                lw.append(module_path + " : " + str(line_nb) + " two or more consecutive empty lines")
                if (edit_files):
                    remove_extra_lines = True
        line_nb += 1
        if (line_nb >= 2):
            prev_line = line

    if (remove_end_lines):
        if (edit_files):
            deleted_lines = False
            passed_end = False
            line_nb = 1

            while (line_nb <= len(list_of_lines)):
                line = list_of_lines[line_nb-1]
                if (line.find(end_token) != -1):
                    passed_end = True
                if (not (passed_end and (line.find(end_token) == -1))):
                    line_nb += 1
                else:
                    deleted_lines = True
                    list_of_lines.pop(line_nb-1)

            if (deleted_lines):
                lw.append(module_path + f" : deleted lines after {end_token}")
            else:
                lw.append(module_path + f" : couldn't delete lines after {end_token} but must!")
        else:
            lw.append(module_path + f" : extra lines after {end_token}")

    if (edit_files and remove_extra_lines):
        line_nb = 1
        prev_line = ""
        while (line_nb <= len(list_of_lines)):
            line = list_of_lines[line_nb-1]
            if (line_nb >= 2):
                if (only_spaces_or_tabs(prev_line) and only_spaces_or_tabs(line)
                    and (not is_comment(prev_line)) and (not is_comment(line))):
                    lw.append(module_path + " : " + str(line_nb) + " removed consecutive empty lines")
                    list_of_lines.pop(line_nb-1)
                else:
                    line_nb += 1
            else:
                line_nb += 1
            if (line_nb >= 2):
                prev_line = line

    # ensure the file ends with a newline
    if list_of_lines and (not list_of_lines[-1].endswith('\n')):
        lw.append(f"{module_path} : file does not end with a newline")
        if edit_files:
            list_of_lines[-1] += '\n'
            add_end_line = True

    return add_end_line


###############################################################################
# Get the nth digit from a number.
# The numbering in this scheme uses zero-indexing and starts from the right side
# of the number.
# The // performs integer division by a power of ten to move the digit to the
# ones position, then the % gets the remainder after division by 10.
###############################################################################
def get_digit (number, n):
    return number // 10**n % 10


###############################################################################
#
# List of files that strings that the module path must not contain, in order to
# check for the license header.
###############################################################################
avoid_list = []
#avoid_list.append("jesd")
avoid_list.append("fir_interp")
avoid_list.append("cic_interp")

def header_check_allowed (module_path):

    for str in avoid_list:
        if (module_path.find(str) != -1):
            return False
    return True


###############################################################################
#
# Check if the license header is written correctly, meaning:
# To have either:
#   - a range of years from the first time it was committed up to the current year,
#   - just the current year, if this is the first commit,
#   - or a comma-separated list combining ranges and/or single years when the
#     gap between the last recorded year and the current year is greater than 1.
###############################################################################
def check_copyright(file_path: str, list_of_lines, lw, edit_files):

    currentYear = datetime.now().year

#    license_header = """// ***************************************************************************
#// ***************************************************************************
#// Copyright (C) """ + str(currentYear) + """ Analog Devices, Inc. All rights reserved.
#//
#// In this HDL repository, there are many different and unique modules, consisting
#// of various HDL (Verilog or VHDL) components. The individual modules are
#// developed independently, and may be accompanied by separate and unique license
#// terms.
#//
#// The user should read each of these license terms, and understand the
#// freedoms and responsibilities that he or she has by using this source/core.
#//
#// This core is distributed in the hope that it will be useful, but WITHOUT ANY
#// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
#// A PARTICULAR PURPOSE.
#//
#// Redistribution and use of source or resulting binaries, with or without modification
#// of this file, are permitted under one of the following two license terms:
#//
#//   1. The GNU General Public License version 2 as published by the
#//      Free Software Foundation, which can be found in the top level directory
#//      of this repository (LICENSE_GPL2), and also online at:
#//      <https://www.gnu.org/licenses/old-licenses/gpl-2.0.html>
#//
#// OR
#//
#//   2. An ADI specific BSD license, which can be found in the top level directory
#//      of this repository (LICENSE_ADIBSD), and also on-line at:
#//      https://github.com/analogdevicesinc/hdl/blob/main/LICENSE_ADIBSD
#//      This will allow to generate bit files and not release the source code,
#//      as long as it attaches to an ADI device.
#//
#// ***************************************************************************
#// ***************************************************************************"""
    changed = False
    header_status = -1

    # for further development, if the entire license should be checked
    # number of lines for the license header text, including the last line
    #lh_nb = license_header.count('\n') + 1

    # if this is the line with the Copyright year
    line_nb = 2
    if line_nb >= len(list_of_lines):
        lw.append(file_path + " : copyright template doesn't match")
        return 4

    line = list_of_lines[line_nb]

    # capture the entire "years" sequence (single / range / comma-separated list)
    # examples matched by (?P<years>...):
    #   "2024"
    #   "2013-2024"
    #   "2013-2017, 2019, 2024"
    m = re.search(
        r'(Copyright\s*\(C\)\s*)(?P<years>(?:20\d{2}(?:\s*-\s*20\d{2})?)(?:\s*,\s*(?:20\d{2}(?:\s*-\s*20\d{2})?))*)',
        line
    )
    if not m:
        lw.append(file_path + " : copyright template doesn't match")
        return 4

    years_str = m.group('years')
    # normalize the years string (spacing and commas) before parsing.
    norm = normalize_str(years_str)

    # parse tokens as a list of dicts: {'t': 'single'|'range', 'a': int, 'b': int}
    tokens_raw = [t.strip() for t in norm.split(",") if t.strip()]
    parsed = []
    for tok in tokens_raw:
        m1 = re.fullmatch(r"(20\d{2})-(20\d{2})", tok)
        if m1:
            a, b = int(m1.group(1)), int(m1.group(2))
            if a > b:
                a, b = b, a
            parsed.append({"t": "range", "a": a, "b": b})
            continue
        m2 = re.fullmatch(r"(20\d{2})", tok)
        if m2:
            y = int(m2.group(1))
            parsed.append({"t": "single", "a": y, "b": y})
            continue

        header_status = 2
        return header_status

    if not parsed:
        header_status = 2
        return header_status

    # last and penultimate visible years (right end of tokens)
    last = parsed[-1]
    last_num = last["b"]
    prev_num = parsed[-2]["b"] if len(parsed) >= 2 else None
    prev_idx = len(parsed) - 2 if len(parsed) >= 2 else None

    proposed = [dict(p) for p in parsed]


    if last_num == currentYear:
        # current year is already present at the end
        if prev_num is not None:
            dif = currentYear - prev_num
            if dif == 1:
                # if the last token is exactly 'current', it should be a range
                if last["a"] == last["b"] == currentYear:
                    lw.append(file_path + " : wrong delimiter between previous year and current; merging into range")
                    if edit_files:
                        if proposed[prev_idx]["t"] == "single":
                            proposed[prev_idx] = {
                                "t": "range",
                                "a": proposed[prev_idx]["a"],
                                "b": currentYear
                            }
                        else:
                            proposed[prev_idx]["b"] = currentYear
                        proposed.pop()
            # if dif > 1: list is correct; do nothing.
            # example: "2013-2020, 2025" stays as list (spacing may be normalized).
        # no penultimate and last == currentYear -> OK (no change). Example: "2025".
    else:
        # current year is missing at the end
        # examples:
        #   "2013-2024" (in 2025) -> warning + "2013-2025" if editing
        #   "2013-2020" (in 2025) -> warning + "2013-2020, 2025" if editing
        lw.append(file_path + " : current year missing; update needed")
        dif = currentYear - last_num
        if dif == 1:
            # extend the last token into a range ending at currentYear
            # examples:
            #   "2024"  -> "2024-2025"
            #   "2013-2024" -> "2013-2025"
            if edit_files:
                if proposed[-1]["t"] == "single":
                    proposed[-1] = {"t": "range", "a": proposed[-1]["a"], "b": currentYear}
                else:
                    proposed[-1]["b"] = currentYear
        elif dif > 1:
            # append ", currentYear"
            # Example: "2013-2020" -> "2013-2020, 2025"
            if edit_files:
                proposed.append({"t": "single", "a": currentYear, "b": currentYear})
        else:
            pass

    proposed_text = ", ".join(
        (f"{t['a']}" if t["a"] == t["b"] else f"{t['a']}-{t['b']}") for t in proposed
    )

    start_i = m.start('years')
    end_i   = m.end('years')
    head = line[:start_i].rstrip()
    tail = line[end_i:]

    tail = re.sub(r'^\s*,\s*', '', tail)
    tail = tail.lstrip()
    tail = (' ' + tail) if tail else ''
    new_line = head + ' ' + proposed_text + tail

    changed = (new_line != line)

    if edit_files and changed:
        # files can be changed and header got updated
        list_of_lines[line_nb] = new_line
        lw.append(file_path + " : license header updated by the script")
        header_status = 1

    elif not edit_files and changed:
        # files not to be edited and header is not up-to-date
        lw.append(file_path + " : license header cannot be updated")
        header_status = 3
    else:
        # files can be changed and header got updated
        header_status = 2

    return header_status


###############################################################################
#
# Check/normalize a typedef (enum/struct/union) block.
# Rules:
#  - base indent >= 2
#  - exactly one space before '{'
#  - inner lines indent = base + 2
#  - items must be on separate lines (no one-liner)
#  - last item without trailing comma
#  - closing on the same line: '} TypeName;'
#  - inline closing comment moved to next line (except one-liner case)
###############################################################################
def _check_typedef_block(idx, line_nb, list_of_lines, lw, edit_files, state):

    path = state.get("path", "<file>")
    if idx >= len(list_of_lines):
        return idx, line_nb

    line = list_of_lines[idx]

    # detect typedef block start
    if not re.match(r"^\s*typedef\s+(enum|struct|union)\b", line):
        return idx, line_nb

    # base indentation (normalize to even >= 2 if editing)
    base_indent = indent_of(line)
    desired_indent = even_indent(base_indent, 2)
    if base_indent != desired_indent:
        emit_line_warning(lw, path, line_nb, idx, idx,
                                f"typedef indentation should be multiple of 2 and >= 2 (now {base_indent})")
        if edit_files:
            list_of_lines[idx] = (" " * desired_indent) + line.lstrip()
            line = list_of_lines[idx]
            base_indent = desired_indent
            state["edited"] = True

    # find the statement end line (';' at top level)
    end_idx = stmt_end_line(list_of_lines, idx)
    if end_idx == -1:
        return idx, line_nb # incomplete typedef

    # locate top-level brace span '{ ... }'
    span = find_top_level_brace_span(list_of_lines, idx, end_idx)
    if span is None:
        # do not normalize if no brace initializer is found
        return idx, line_nb

    open_l, open_c, close_l, close_c = span
    is_one_line = (open_l == close_l)

    # split parts: header (up to '{'), inside text, and trailer after '}'
    header_line = list_of_lines[open_l][:open_c]
    inside_text = extract_between_braces(list_of_lines, open_l, open_c, close_l, close_c)

     # collect text after '}' up to end of statement (may span multiple lines)
    trailer_after = list_of_lines[close_l][close_c+1: (len(list_of_lines[close_l]) if end_idx == close_l else None)]
    if close_l < end_idx:
        trailer_after = (trailer_after or "") + "".join(list_of_lines[close_l+1:end_idx+1])

    # extract TypeName; and optional inline //comment appearing after '}'
    m_t = re.search(r"\}\s*([A-Za-z_]\w*)\s*;\s*(//.*)?", "}" + trailer_after)
    typename = None
    inline_cmt = ""
    next_line_had_typename = False
    if m_t:
        typename = m_t.group(1)
        inline_cmt = (m_t.group(2) or "").strip()
    if not typename and (close_l + 1) <= end_idx:
        m_next = re.match(r"^\s*([A-Za-z_]\w*)\s*;\s*(//.*)?\n?$", list_of_lines[close_l + 1])
        if m_next:
            typename = m_next.group(1)
            next_line_had_typename = True
    if not typename:
        return idx, line_nb

    # exactly one space before '{'
    if header_line.strip():
        trailing_spaces = len(header_line) - len(header_line.rstrip(" "))
        if trailing_spaces != 1:
            emit_line_warning(lw, path, line_nb, idx, open_l,
                                    "one space required before '{' in typedef")

    # no one-liner: items must be on separate lines
    if is_one_line:
        emit_line_warning(lw, path, line_nb, idx, open_l,
                                "typedef items must be on separate lines")
    else:
        # first item must not share the '{' line
        after_open = list_of_lines[open_l][open_c+1:]
        code_after, _ = split_code_comment_sl(after_open)
        if code_after.strip():
            emit_line_warning(lw, path, line_nb, idx, open_l,
                                    "first item in typedef must start on a new line")

    # inner lines: indent must be base + 2 (skip comments/empty/backticks)
    if not is_one_line:
        for j in range(open_l + 1, close_l):
            s = list_of_lines[j]
            if only_spaces_or_tabs(s) or is_cmt(s) or ("`" in s):
                continue
            if "{" in s or "}" in s:
                continue
            if indent_of(s) < (base_indent + 2):
                emit_line_warning(lw, path, line_nb, idx, j,
                                        "inner line in typedef must be indented by +2 spaces")

    # find last code line before '}' to check if it ends with ','
    j_last = None
    last_code = ""
    for j in range(close_l, open_l, -1):
        s = list_of_lines[j]
        seg = s[:close_c] if j == close_l else s
        code, _ = split_code_comment_sl(seg)
        code = code.rstrip()
        if code:
            j_last, last_code = j, code
            break

    if j_last is not None and last_code.endswith(","):
        emit_line_warning(lw, path, line_nb, idx, j_last,
                                "last entry in typedef must not end with ','")

    # '}' must align with the typedef line indentation
    if indent_of(list_of_lines[close_l]) != base_indent:
        emit_line_warning(lw, path, line_nb, idx, close_l,
                                "'}' in typedef must align with typedef line")

    # closing must be on the same line as '} TypeName;
    if next_line_had_typename:
        emit_line_warning(lw, path, line_nb, idx, close_l + 1,
                                "typedef closing must be on the same line as '} TypeName;'")

     # inline comment after the closing is moved to next line (for multi-line case)
    if inline_cmt and not is_one_line:
        emit_line_warning(lw, path, line_nb, idx, close_l,
                                "move inline comment to the next line")

    # header: enforce single space before '{'; keep any header //comment on its own line at +2
    h_code, h_cmt = split_code_comment_sl(header_line or "")
    h_code = h_code.rstrip()

    canonical = []
    canonical.append((" " * base_indent) + h_code.lstrip() + " {\n")

    # header // comment moved to next line (indented by base + 2)
    if h_cmt:
        canonical.append((" " * (base_indent + 2)) + h_cmt.strip() + "\n")

     # split inner text by top-level commas; strip trailing ';'; keep ',' only for non-last items
    raw_items = [it.strip() for it in split_top_level_commas(inside_text)]
    items = [it for it in raw_items if it]
    for k, it in enumerate(items):
        comma = "," if k < len(items) - 1 else ""
        canonical.append((" " * (base_indent + 2)) + strip_trailing_semicol(it) + comma + "\n")

    # closing and type on the same line
    canonical.append((" " * base_indent) + f"}} {typename};\n")

    # move inline closing comment to a new line (multi-line only)
    if inline_cmt and not is_one_line:
        canonical.append((" " * base_indent) + inline_cmt + "\n")

    new_block = canonical
    old_block = list_of_lines[idx:end_idx+1]

    # replace atomically if changes are needed
    if edit_files and old_block != new_block:
        replace_block_atomic(list_of_lines, idx, end_idx, new_block)
        state["edited"] = True

    return idx, line_nb


###############################################################################
#
# Check for guideline rules applied to module definitions and the entire file,
# except for the module instances. They are processed in check_guideline_instances.
# This can modify the files if edit_files is true.
# Return the string containing the module name and print errors for guideline
#        if it is not respected.
###############################################################################
def get_and_check_module (module_path, lw, edit_files):

    lw_initial_size = len(lw)
    lw.append("\nAt module definition:")

    fp = open("%s" % (module_path), "r")
    list_of_lines = fp.readlines()
    fp.close()

    ## do not check the license status for the files that must be avoided,
    ## since it doesn't apply
    if (header_check_allowed(module_path)):
        header_status = check_copyright(module_path, list_of_lines, lw, edit_files)
        # GC: check if the license header is updated
        if (header_status == -1):
            edited = False
            lw.append(module_path + " : copyright text doesn't match the pattern for the Copyright year")
    else:
        header_status = -1

    module_name = ""
    name_found = False
    params_exist = False
    end_line = -1
    line_nb = 1
    passed_module = False
    passed_endmodule = False
    last_iodef_line = -1
    last_paramdef_line = -1
    changed_line1 = -1
    changed_line2 = -1
    changed_line1_sit = -1
    extra_chars = False

    typedef_state = {
        "open": False,
        "base_indent": 0,
        "open_idx": -1,
        "path": module_path,
        "edited": False
    }

    for idx, line in enumerate(list_of_lines):
        pos_module = line.find("module")
        pos_endmodule = line.find("endmodule")
        pos_paranth1 = line.find("(")
        pos_comma = line.find(",")

        if (pos_module == 0):
            passed_module = True

        if (pos_endmodule != -1):
            passed_endmodule = True

        # typedef inside of the module
        if passed_module and (not passed_endmodule):
            idx, line_nb = _check_typedef_block(idx, line_nb, list_of_lines, lw, edit_files, typedef_state)

        # GC: check for spaces at the end of line
        if (re.search(" +$", line) != None):
            extra_chars = True
            lw.append(module_path + " : " + str(line_nb) + " extra spaces at the end of line")

        # if the module declaration didn't end already
        if (is_paramdef(line) and passed_module and end_line == -1):
            if (pos_comma == -1):
                last_paramdef_line = line_nb
            else:
                pos_comment = line.find("/")
                ## if the first found comma is after a /, it means it's the
                ## last parameter line
                if (pos_comment > 0 and pos_comment < pos_comma):
                    last_paramdef_line = line_nb

        # if the module declaration didn't end already
        if (is_iodef(line) and passed_module and end_line == -1):
            if (pos_comma == -1):
                last_iodef_line = line_nb
            else:
                pos_comment = line.find("/")
                ## if the first found comma is after a /, it means it's the
                ## last io line
                if (pos_comment > 0 and pos_comment < pos_comma):
                    last_iodef_line = line_nb

        # if still inside the module declaration (with params)
        if (name_found and params_exist and end_line == -1):
            pos_paranth2 = line.find(")")

            if (0 <= pos_paranth2 and pos_paranth2 < pos_paranth1):
                if (re.search("\)\\s\(", line) != None):

                    rest_of_line = line.strip().strip("(").strip().strip(")")
                    ## GC: situations when the guideline is not respected:
                    ## 1. |      ) (
                    ## 2. |) (  something
                    ## 3. |  smth  ) (   something
                    ## 4. means it's one of the above
                    if (pos_paranth2 > 0 or rest_of_line != ""):
                        changed_line1_sit = 4
                        lw.append(module_path + " : " + str(line_nb) + " at ) ( not at the beginning of an empty line")

                    if (edit_files):
                        # situation 1: clear before ) (
                        if (pos_paranth2 > 0 and rest_of_line == ""):
                            changed_line1_sit = 1

                            aux = list(list_of_lines[line_nb-1])
                            auxf = [")", " ", "("]
                            l = 0
                            for c in aux:
                                # remove the ), the space and the (
                                if (l != pos_paranth2 and (l != pos_paranth2 + 1) and l != pos_paranth1):
                                    auxf.append(c)
                                l += 1
                            list_of_lines[line_nb-1] = "".join(auxf)
                            changed_line1 = line_nb

                        # situation 2: add a newline
                        if (pos_paranth2 == 0 and rest_of_line != ""):
                            changed_line1_sit = 2

                            aux = list(list_of_lines[line_nb-1])
                            auxf = []
                            l = 0
                            for c in aux:
                                # remove the ), the space and the (
                                if (l != pos_paranth2 and (l != pos_paranth2 + 1) and l != pos_paranth1):
                                    auxf.append(c)
                                l += 1
                            list_of_lines[line_nb-1] = "".join(auxf)
                            changed_line1 = line_nb

                        # situation 3: clear before ) ( and add a newline
                        if (pos_paranth2 > 0 and rest_of_line != ""):
                            changed_line1_sit = 3

                            aux = list(list_of_lines[line_nb-1])
                            auxf = []
                            l = 0
                            for c in aux:
                                # remove the ), the space and the (
                                if (l != pos_paranth2 and (l != pos_paranth2 + 1) and l != pos_paranth1):
                                    auxf.append(c)
                                l += 1
                            list_of_lines[line_nb-1] = "".join(auxf)
                            changed_line1 = line_nb
                else:
                    lw.append(module_path + " : " + str(line_nb) + " at ) ( has to have exactly 1 space between")

        # if still inside the module declaration and regardless of params
        if (name_found and end_line == -1):
            pos_closing = line.find(");")

            if (pos_closing >= 0):
                if idx > 0:
                    prev_line = list_of_lines[idx - 1].rstrip("\n")
                    if prev_line.rstrip().endswith(","):
                        lw.append(f"{module_path} : {line_nb-1} last port in module must not end with ','")
                        if edit_files:
                            list_of_lines[idx - 1] = prev_line.rstrip().rstrip(",") + "\n"

                end_line = line_nb
                if ((last_iodef_line + 1 != line_nb) or (pos_closing >= 0)):
                    rest_of_line = line.strip().strip(";").strip().strip(")")

                    if (pos_closing > 0 or rest_of_line != ""):
                        lw.append(module_path + " : " + str(line_nb) + " at ); not at the beginning of the next line after the last port")

                    if (edit_files):
                        if (pos_closing > 0 or rest_of_line != ""):
                            aux = list(list_of_lines[line_nb-1])
                            auxf = []
                            l = 0
                            for c in aux:
                                # remove the ) and ;
                                if (l != pos_closing and (l != pos_closing + 1)):
                                    auxf.append(c)
                                l += 1
                            list_of_lines[line_nb-1] = "".join(auxf)
                            changed_line2 = line_nb

        # GC: check for indentation of the file
        ## if it's a regular line
        if ((pos_module == -1) and (pos_endmodule == -1)
            and (not only_spaces_or_tabs(line))
            and (not is_cmt(line))
            and passed_module and (not passed_endmodule)
            and (line.find("`") == -1)):
            indent_nb = len(line) - len(line.lstrip())

            if (not (indent_nb >= 2)):
                if (line_nb != (last_paramdef_line+1) and line_nb != (last_iodef_line+1)):
                    lw.append(module_path + " : " + str(line_nb) + " no indentation found")
            else:
                # take only iodef from modules and not from functions also
                if (indent_nb != 2 and is_paramdef(line)):
                    lw.append(module_path + " : " + str(line_nb) + " indentation is not proper")

        # get the module name by reading the line that contains "module"
        # GC: check for proper positioning of the module declaration
        if ((not is_comment(line)) and (not name_found)):
            if (pos_module == 0):
                ## situations accepted
                ## 1. module module_name (
                ## 2. module module_name #(

                pos_diez = line.find("#")
                # 2nd situation
                if (pos_diez > 0):
                    if (pos_paranth1 == pos_diez + 1):
                        module_name = re.search("module(.*?)#\(", line)
                        if (module_name != None):
                            module_name = module_name.group(1)
                            module_name = module_name.strip()
                            name_found = True
                        else:
                            lw.append(module_path + " : " + str(line_nb) + " at module name - error")
                    else:
                        lw.append(module_path + " : " + str(line_nb) + " at module #( guideline not respected")

                    params_exist = True
                # 1st situation
                else:
                    module_name = line.strip("module")
                    module_name = module_name.strip()
                    module_name = module_name.strip("\n")
                    module_name = module_name.strip()
                    module_name = module_name.strip("(")
                    module_name = module_name.strip()
                    name_found = True
        line_nb += 1

    if (edit_files):
        if (changed_line1 != -1):
            if (changed_line1_sit == 2 or changed_line1_sit == 3):

                insert_pos = changed_line1

                cur_idx = changed_line1 - 1
                if 0 <= cur_idx < len(list_of_lines):
                    raw = list_of_lines[cur_idx]
                    p = raw.find("//")
                    if p != -1:
                        # if the comment starts with 'end...' -> insert BEFORE it so it gets pushed down
                        after = raw[p+2:].lstrip()
                        if after.lower().startswith("end"):
                            insert_pos = cur_idx

                        # if the line is ONLY a comment (only whitespace before '//'),
                        # enforce 2 spaces at the start of the comment line
                        if raw[:p].strip() == "":
                            list_of_lines[cur_idx] = "  " + raw[p:].strip() + "\n"

                # insert the new line with 2 leading spaces
                list_of_lines.insert(insert_pos, "  ) (\n")

        if (changed_line2 != -1):
            if (changed_line1 != -1 and changed_line1_sit > 1):
                changed_line2 += 1
                last_iodef_line += 1
            ## +1 -1 because we want on the next line after the last iodef line,
            ## but also the counting with line_nb starts from 1, and in
            ## files it starts from 0
            list_of_lines.insert((last_iodef_line + 1) - 1, ");\n")

    # GC: check for lines after endmodule and empty lines
    # (and delete them, if desired)
    prev_length = len(list_of_lines)
    changed_extra = check_extra_lines (module_path, list_of_lines, lw, edit_files)


    if (edit_files):
        # if at least one of the things was edited
        if (changed_line1 != -1 or changed_line2 != -1 or extra_chars
            or prev_length != len(list_of_lines)
            or (header_status == 1) or typedef_state["edited"]
            or changed_extra):

            rewrite_file(module_path, list_of_lines)

            if extra_chars:
                lw.append(module_path + " : removed extra spaces at the end of lines")

            if changed_extra:
                lw.append(module_path + " : add new line after end token")

    if (not name_found):
        lw.append(module_path + " : module name couldn't be extracted\n")

    lw_last_size = len(lw)
    if (lw_last_size == lw_initial_size + 1):
        lw.pop()

    return module_name


###############################################################################
#
# Check for guideline rules applied to package definitions in SystemVerilog files.
# Similar to get_and_check_module but adapted for package-specific rules.
# This can modify the files if edit_files is true.
# Return the string containing the package name and print errors if guideline
# is not respected.
###############################################################################
def get_and_check_package(package_path, lw, edit_files):

    lw_initial_size = len(lw)
    lw.append("\nAt package definition:")

    fp = open("%s" % (package_path), "r")
    list_of_lines = fp.readlines()
    fp.close()

    # Do not check license for files that must be avoided
    if header_check_allowed(package_path):
        header_status = check_copyright(package_path, list_of_lines, lw, edit_files)
        if header_status == -1:
            lw.append(f"{package_path} : copyright text doesn't match the pattern")
    else:
        header_status = -1

    package_name = ""
    name_found = False
    passed_package = False
    passed_endpackage = False
    end_line = -1
    extra_chars = False

    changed_pkg_line = -1
    changed_endpkg_line = -1

    # typedef normalization state
    typedef_state = {
        "open": False,
        "base_indent": 0,
        "open_idx": -1,
        "path": package_path,
        "edited": False,
    }

    line_nb = 1
    for idx, line in enumerate(list_of_lines):
        pos_package    = line.find("package")
        pos_endpackage = line.find("endpackage")

        # trailing spaces
        if re.search(r" +$", line) is not None:
            extra_chars = True
            lw.append(package_path + " : " + str(line_nb) + " extra spaces at the end of line")

        # package start: canonical 'package <name>;'
        if (pos_package == 0) and (not name_found) and (not is_cmt(line)):
            passed_package = True

            m_can = re.match(r"^package\s+([A-Za-z_][A-Za-z0-9_$]*)\s*;\s*(//.*)?\n?$", line)
            if m_can:
                package_name = m_can.group(1)
                name_found = True

                fixed = f"package {package_name};"
                if m_can.group(2):
                    fixed += " " + m_can.group(2)
                fixed += "\n"

                if fixed != line:
                    lw.append(package_path + " : " + str(line_nb) + " normalize 'package <name>;' (no space before and after ';')")
                    if edit_files:
                        list_of_lines[idx] = fixed
                        changed_pkg_line = line_nb
            else:
                # try to extract a valid name and rebuild canonical line
                m_name = re.match(r"^package\s+([A-Za-z_][A-Za-z0-9_$]*)", line)
                if m_name:
                    package_name = m_name.group(1)
                    name_found = True
                    lw.append(package_path + " : " + str(line_nb) + " package line must be 'package <name>;' at column 0")
                    if edit_files:
                        # preserve trailing // comment if any
                        comment = ""
                        tail = line[len(m_name.group(0)):]
                        if "//" in tail:
                            _, cmt = tail.split("//", 1)
                            comment = "//" + cmt.strip()
                        fixed = f"package {package_name};"
                        if comment:
                            fixed += " " + comment
                        fixed += "\n"
                        list_of_lines[idx] = fixed
                        changed_pkg_line = line_nb
                else:
                    lw.append(package_path + " : " + str(line_nb) + " package name couldn't be extracted")

        # endpackage: must be alone on its line at column 0
        if (pos_endpackage == 0) and (not is_cmt(line)):
            passed_endpackage = True
            end_line = line_nb
            if re.match(r"^endpackage\s*(//.*)?\n?$", line) is None:
                lw.append(package_path + " : " + str(line_nb) + " 'endpackage' must be alone on its line at column 0")
                if edit_files:
                    list_of_lines[idx] = "endpackage\n"
                    changed_endpkg_line = line_nb

        inside_pkg = passed_package and (not passed_endpackage)
        if inside_pkg:
            # typedef normalization
            idx, line_nb = _check_typedef_block(idx, line_nb, list_of_lines, lw, edit_files, typedef_state)

            # minimal indentation rule for other top-level lines (>= 2 spaces),
            # excluding lines with directives/backticks or comments.
            if (not only_spaces_or_tabs(line)) and (not is_cmt(line)) and (line.find("`") == -1):
                if (pos_package == -1) and (pos_endpackage == -1) and (not typedef_state["open"]):
                    indent_nb = indent_of(line)
                    if indent_nb < 2:
                        lw.append(package_path + " : " + str(line_nb) + " no indentation found (need >= 2 spaces)")

        line_nb += 1

    # remove extra lines after endpackage / empty lines
    prev_length = len(list_of_lines)
    changed_extra = check_extra_lines(package_path, list_of_lines, lw, edit_files, end_token="endpackage")

    # Rewrite file if needed
    if edit_files:
        if (changed_pkg_line != -1 or changed_endpkg_line != -1
            or extra_chars or (prev_length != len(list_of_lines))
            or (header_status == 1) or typedef_state["edited"]
            or changed_extra):

            rewrite_file(package_path, list_of_lines)

            if extra_chars:
                lw.append(package_path + " : removed extra spaces at the end of lines")

            if changed_extra:
                lw.append(package_path + " : add new line after end token")

    if not name_found:
        lw.append(package_path + " : package name couldn't be extracted")

    # remove the section title if nothing else was logged
    if len(lw) == lw_initial_size + 1:
        lw.pop()

    return package_name


# Global cache: projects that were already checked for system_project.tcl
PROJECTS_CHECKED = set()

###############################################################################
#
# Check if the project name in the system_project.tcl file matches the
# expected name, which is the relative path from the projects folder,
###############################################################################
def check_project_name_vs_path(modified_files, lw, edit_files=False, checked_projects=None):

    if checked_projects is None:
        checked_projects = PROJECTS_CHECKED

    projects_abs = os.path.abspath("projects")

    for f in modified_files:
        folder = os.path.abspath(os.path.dirname(f))
        # Walk upward as long as we're inside <repo>/projects, but not at its root
        while os.path.commonpath([folder, projects_abs]) == projects_abs and os.path.basename(folder) != "projects":
            tcl_path = os.path.join(folder, "system_project.tcl")

            if os.path.exists(tcl_path) and folder not in checked_projects:
                rel_path = os.path.relpath(folder, projects_abs)
                expected_name = rel_path.replace(os.sep, "_")

                lines, found, changed = [], False, False

                with open(tcl_path, "r") as tclf:
                    for line in tclf:
                        m = re.match(r'\s*adi_project\s+(\S+)', line)
                        if m:
                            found = True
                            found_name = m.group(1)
                            if found_name != expected_name:
                                lw.append(f"{f} : adi_project '{found_name}' does not match expected '{expected_name}'")
                                if edit_files:
                                    line = re.sub(r'(\s*adi_project\s+)\S+', r'\1' + expected_name, line)
                                    changed = True
                        lines.append(line)

                if edit_files and found and changed:
                    with open(tcl_path, "w") as tclf:
                        tclf.writelines(lines)
                    lw.append(f"{tcl_path} : adi_project updated to '{expected_name}'")

                checked_projects.add(folder)
                break

            folder = os.path.dirname(folder)


###############################################################################
#
# Find all occurrences of the given module (path) in all files from the given
# directory (recursively, but only in \library or \projects) or in all files
# from list_of_files (if specified).
# Return list of paths (for the occurrences) relative to the given directory.
###############################################################################
def find_occurrences (directory, module_name, list_of_files):

    occurrences_list = []
    for folder, dirs, files in os.walk(directory):

        ## only folder paths without a dot
        ## and to be either from /library or from /projects
        if (not ((folder[1:-2]).find(".") == -1
            and (folder.find("library") != -1 or folder.find("projects") != -1))):
            continue

        for file in files:
            fullpath = os.path.join(folder, file)

            if (not check_hdl_filename(fullpath)):
                continue

            search = False
            if (list_of_files and (string_in_list(fullpath, list_of_files))):
                search = True
            elif (not list_of_files):
                search = True

            ## the file with the module definition is not accepted and
            ## neither the files that have to be avoided
            if search and file not in (module_name + ".v", module_name + ".sv"):
                with codecs.open(fullpath, 'r', encoding='utf-8', errors='ignore') as f:
                    line_nb = 1

                    for line in f:
                        if ((line.find(module_name) != -1) and (not is_comment(line))):
                            pos = line.find(module_name)
                            pos_dot = line.find(".")

                            # if there is no dot before the module name
                            if (pos_dot == -1 or pos < pos_dot):
                                if ((line[pos+len(module_name)] == ' ') or (line[pos+len(module_name)] == '#')
                                    or (line[pos+len(module_name)] == '(') or (line[pos+len(module_name)] == '\t')):
                                    # if before the instance name there are only spaces, then it is ok
                                    if (only_spaces_or_tabs(line[:pos-1]) == True):
                                        new_occurrence = Occurrence(path=fullpath, line=line_nb)
                                        ## check if it has a parameters list;
                                        ## then instance name is on the same line
                                        if ("#" not in line):
                                            new_occurrence.pos_start_ports = 0
                                        occurrences_list.append(new_occurrence)
                        line_nb += 1
    return occurrences_list


###############################################################################
#
# Find the lines where an occurrence starts, ends and where its list of ports
# starts.
# Return nothing (the occurrence_item fields are directly modified)
###############################################################################
def set_occurrence_lines (occurrence_item, list_of_lines):

    pos_start_module = -1
    pos_end_module = -1
    param_exist = False
    instance_lines = []

    line_nb = 1
    # find the start and the end line of the module instance
    for line in list_of_lines:
        if (pos_end_module == -1):
            if (occurrence_item.line == line_nb):
                pos_start_module = line_nb

                if ("#" in line):
                    param_exist = True

            # if we are inside of the module instance
            if (pos_start_module != -1):
                if (line.find(");") != -1):
                    pos_end_module = line_nb
                    occurrence_item.line_end = pos_end_module
        else:
            break
        line_nb += 1

    if (not param_exist):
        occurrence_item.pos_start_ports = 0
    else:
        # with parameters: get the ports' list in all_inst_lines, including parameters
        all_inst_lines = ""
        line_nb = 1
        for line in list_of_lines:
            if (pos_start_module <= line_nb and line_nb <= pos_end_module):
                all_inst_lines = all_inst_lines + line
            elif (line_nb > pos_end_module):
                break
            line_nb += 1

        ## find the line where the instance name is;
        ## the ports should start from the next line, which is pos_start_ports+1

        # find a string that is spread over multiple lines
        aux_instance_name = re.findall('\)\n(.*?)\(', all_inst_lines, re.M)

        # if )\n i_... (
        if (len(aux_instance_name) > 0):
            instance_name = aux_instance_name[0].strip(" ")
        else:
            # if ) i_... (
            instance_name = re.findall('\)(.*?)\(', all_inst_lines, re.M)[0].strip(" ")

        line_nb = 1
        pos_start_ports = -1
        # update occurrence_item.pos_start_ports if it wasn't already set
        for line in list_of_lines:
            if (pos_start_module <= line_nb and line_nb <= pos_end_module):
                if ((instance_name in line) and (pos_start_ports == -1)):
                    # if not already specified in find_occurrences, without a parameters list
                    if (occurrence_item.pos_start_ports == -1):
                        pos_start_ports = line_nb - pos_start_module
                        occurrence_item.pos_start_ports = pos_start_ports
            elif (line_nb > pos_end_module):
                break
            line_nb += 1


###############################################################################
#
# Check for the guideline rules applied to the module instances and output
# warnings for each line, if any.
###############################################################################
def check_guideline_instances (occurrence_item, lw):

    # list of warnings
    lw_initial_size = len(lw)
    lw.append("\nAt instances:")

    with open(occurrence_item.path, 'r') as in_file:
        list_of_lines = in_file.readlines()

    # have all the fields of the occurrence_item
    set_occurrence_lines(occurrence_item, list_of_lines)

    ## with parameters: get the module instance's lines in all_inst_lines,
    ## including the parameters
    all_inst_lines = ""
    line_nb = 1

    for line in list_of_lines:
        if (occurrence_item.line <= line_nb and line_nb <= occurrence_item.line_end):
            all_inst_lines = all_inst_lines + line
        elif (line_nb > occurrence_item.line_end):
            break
        line_nb += 1

    port_pos = 0
    line_nb = 1
    spaces_nb = -1
    passed_module = False
    passed_endmodule = False

    for line in list_of_lines:
        inside_module_instance = False
        line_start_ports = occurrence_item.line + occurrence_item.pos_start_ports

        if ((occurrence_item.line <= line_nb) and (line_nb <= occurrence_item.line_end)):
            inside_module_instance = True

            # GC: indentation for the line where the instance name is
            if (line_start_ports == line_nb):
                spaces_nb = len(line) - len(line.lstrip())
                if ((spaces_nb <= 0) or (spaces_nb % 2 != 0)):
                    lw.append(occurrence_item.path + " : " + str(line_nb) + " wrong indentation at instance name")

            # GC: indentation for the line where the module name is
            if (occurrence_item.line == line_nb):
                start_spaces_nb = len(line) - len(line.lstrip())
                if ((start_spaces_nb <= 0) or (start_spaces_nb % 2 != 0)):
                    lw.append(occurrence_item.path + " : " + str(line_nb) + " wrong indentation at module name")

        # GC: check for proper positioning of the module instance
        if (inside_module_instance):
            if ("#" in line):
                diez_ok = False

                if ("." in line):
                    lw.append(occurrence_item.path + " : " + str(line_nb) + " #(. in module instance")
                else:
                    pos_diez = line.find("#")
                    pos_paranth1 = line.find("(")
                    pos_paranth2 = line.find(")")

                    if ((0 < pos_diez) and (pos_diez + 1 == pos_paranth1) and (pos_paranth2 == -1)):
                        diez_ok = True
                    else:
                        if (pos_paranth2 != -1):
                            lw.append(occurrence_item.path + " : " + str(line_nb) + " parameters must be each on its own line")
                        else:
                            lw.append(occurrence_item.path + " : " + str(line_nb) + " parameters list is not written ok")

                    # for the line where the instance name is
                    # find a string like )\n ... (
                    aux_instance_name = re.findall('\)\n(.*?)\(', all_inst_lines, re.M)
                    instance_name = ""

                    # if )\n i_... (
                    if (len(aux_instance_name) > 0):
                        instance_name = aux_instance_name[0].strip(" ")
                        if (")" not in instance_name):
                            lw.append(occurrence_item.path + " : " + str(line_start_ports) + " ) i_... ( instance name not written ok")

                    else:
                        try:
                            # if ) i_... (
                            instance_name = re.findall('\)(.*?)\(', all_inst_lines, re.M)[0].strip(" ")
                        except Exception:
                            lw.append(occurrence_item.path + " : " + str(occurrence_item.line + occurrence_item.pos_start_ports) + " couldn't extract instance name")

            pos_dot = line.find(".")
            pos_comma = line.find(",")
            pos_closing = line.find(");")

            # GC: all ); of instances cannot be on an empty line
            aux_line = line.strip()
            aux_line = aux_line.strip("\t")
            aux_line = aux_line.strip(")")
            aux_line = aux_line.strip(";")
            if ((pos_closing != -1) and (only_spaces_or_tabs(aux_line))):
                lw.append(occurrence_item.path + " : " + str(line_nb) + " ); when closing module instance")

            # every dot starting from (.line + .pos_start_ports) line means a new port is declared
            if ((line_start_ports <= line_nb) and (pos_dot != -1)):
                port_indentation = len(line) - len(line.lstrip())
                port_pos += 1

                # 1. the first port in the module instance
                # 2. anywhere inside the instance, but not the first or last
                # 3. when .port());
                # 4. last port when .port()\n  and ); is on the next line

                # no situation or error situation
                situation = 0
                inst_closed = False
                if (pos_closing != -1):
                    inst_closed = True

                # 1st situation
                if (port_pos == 1):
                    situation = 1
                else:
                    # 3rd situation
                    if ((pos_dot != -1) and inst_closed):
                        situation = 3
                    else:
                        # 4th situation
                        if ((pos_dot != -1) and (pos_comma == -1) and (not inst_closed)):
                            situation = 4
                        else:
                            # 2nd situation
                            if ((pos_dot != -1) and (pos_comma != -1) and (not inst_closed)):
                                situation = 2
                            else:
                                lw.append(occurrence_item.path + " : " + str(line_nb) + " problem when finding the situation")

                if (situation != 0):
                    # the rest of the ports must have the same indentation as the previous line
                    if (port_indentation - spaces_nb != 2):
                        avoid_indentation_check = False

                        if ((line.find("({") != -1) or (line.find("})") != -1)):
                            avoid_indentation_check = True

                        if (not avoid_indentation_check):
                            lw.append(occurrence_item.path + " : " + str(line_nb) + " indentation inside module instance")
            else:
                # if inside the parameters list
                if (occurrence_item.line <= line_nb and line_nb < line_start_ports and (pos_dot != -1)):
                    param_indentation = len(line) - len(line.lstrip())
                    if (param_indentation - start_spaces_nb != 2):
                        lw.append(occurrence_item.path + " : " + str(line_nb) + " indentation inside parameters list")

        line_nb += 1

        if (line_nb > occurrence_item.line_end):
            break

    lw_last_size = len(lw)

    if (lw_last_size == lw_initial_size + 1):
        lw.pop()

###############################################################################
#
# Check guideline for Verilog and SystemVerilog files in repository
###############################################################################

## all files given as parameters to the script (or all files from repo
## if no flag is specified)
modified_files = []
error_files = []
edit_files = False
guideline_ok = True
# detect all modules from current directory (hdl)
all_hdl_files = detect_all_hdl_files("./")


xilinx_modules = []
xilinx_modules.append("ALT_IOBUF")
xilinx_modules.append("BUFG")
xilinx_modules.append("BUFG_GT")
xilinx_modules.append("BUFGCE")
#xilinx_modules.append("BUFGCE_1")
xilinx_modules.append("BUFGCE_DIV")
xilinx_modules.append("BUFGCTRL")
xilinx_modules.append("BUFGMUX")
#xilinx_modules.append("BUFGMUX_1")
xilinx_modules.append("BUFGMUX_CTRL")
xilinx_modules.append("BUFH")
xilinx_modules.append("BUFIO")
xilinx_modules.append("BUFR")
xilinx_modules.append("GTHE3_CHANNEL")
xilinx_modules.append("GTHE4_CHANNEL")
xilinx_modules.append("GTYE4_CHANNEL")
xilinx_modules.append("GTXE2_CHANNEL")
xilinx_modules.append("IBUFDS")
xilinx_modules.append("IBUFDS_GTE2")
xilinx_modules.append("IBUFDS_GTE3")
xilinx_modules.append("IBUFDS_GTE4")
xilinx_modules.append("IBUFDS_GTE5")
xilinx_modules.append("IBUFG")
xilinx_modules.append("IDDR")
xilinx_modules.append("IDELAYCTRL")
xilinx_modules.append("ISERDESE2")
xilinx_modules.append("OBUFDS")
xilinx_modules.append("ODDR")
xilinx_modules.append("system_bd")
xilinx_modules.append("system_wrapper")

# if there is an argument specified
if (len(sys.argv) > 1):

    # -m means a file name/s will be specified (including extension!)
    # mostly used for testing manually, changing the folder_path
    # -me means that it will also modify the files
    if (sys.argv[1] == "-m" or sys.argv[1] == "-me"):
        if (sys.argv[1] == "-me"):
            edit_files = True

        arg_nb = 2

        while (arg_nb < len(sys.argv)):
            # look in the folder_path = current folder
            for folder, dirs, files in os.walk("./"):
                for name in files:
                    if((name == sys.argv[arg_nb]) and (check_hdl_filename(name))):
                        #module_path = os.path.abspath(os.path.join(folder, sys.argv[arg_nb]))
                        file_path = os.path.join(folder, sys.argv[arg_nb])
                        modified_files.append(file_path)
            arg_nb += 1

    # -p means a path/s will be specified
    # mostly used for github action
    # -pe means that it will also modify the files
    if (sys.argv[1] == "-p" or sys.argv[1] == "-pe"):
        if (sys.argv[1] == "-pe"):
            edit_files = True

        arg_nb = 2
        while (arg_nb < len(sys.argv)):
            if (os.path.exists(sys.argv[arg_nb])):
                if (check_hdl_filename(sys.argv[arg_nb])):
                    modified_files.append(sys.argv[arg_nb])
            else:
                print(f"File {sys.argv[arg_nb]} doesn't exist!")
                error_files.append(sys.argv[arg_nb])
            arg_nb += 1

    # -e means it will be run on all files, making changes in them
    if (sys.argv[1] == "-e"):
        edit_files = True
        modified_files = detect_all_hdl_files("./")

else:
    ## if there is no argument then the script is run on all files,
    ## and without making changes in them
    edit_files = False
    modified_files = detect_all_hdl_files("./")

# no matter the number of arguments
if (len(modified_files) <= 0):
    print("NO detected modules")
    guideline_ok = True
    sys.exit(0)
else:
    for file_path in all_hdl_files:

        file_name = get_file_name(file_path)
        pkg_module_name = file_name
        # list of warnings
        lw = []

        # if the detected module is between the modified files
        if (string_in_list(file_path, modified_files)):
            if detect_file_unit_(file_path) == "package":
                # if the file is a package, then check the package definition
                pkg_module_name = get_and_check_package(file_path, lw, edit_files=edit_files)
            else:
                # if the file is a module, then check the module definition
                pkg_module_name = get_and_check_module(file_path, lw, edit_files=edit_files)

            # file_name is without the known extension, which is .v or .sv
            if (pkg_module_name != file_name):
                print(f"\n -> pkg_module_name {pkg_module_name} != file_name {file_name}")
                # applies only to the library folder
                if (file_path.find("library") != -1):
                    guideline_ok = False
                    error_files.append(file_path)
            # check if the project name matches the path and add warnings to the same lw list
            check_project_name_vs_path([file_path], lw, edit_files, checked_projects=PROJECTS_CHECKED)

        ## system_top modules won't be instantiated anywhere in other
        ## Verilog or SystemVerilog files
        if (file_path.find("system_top") == -1):
            # will search for instances only in the files given as arguments
            occurrences_list = find_occurrences("./", pkg_module_name, modified_files)
            if (len(occurrences_list) > 0):
                for occurrence_item in occurrences_list:
                    check_guideline_instances(occurrence_item, lw)

        if (len(lw) > 0):
            guideline_ok = False
            print ("\n -> For %s in:" % file_path)
            for message in lw:
                print(message)

    for file_name in xilinx_modules:
        lw = []
        xilinx_occ_list = find_occurrences("./", file_name, modified_files)

        if (len(xilinx_occ_list) > 0):
            for xilinx_occ_it in xilinx_occ_list:
                # if the xilinx module was found in the files that are of interest
                for it in all_hdl_files:
                    if (xilinx_occ_it.path == it):
                        # only then to check the guideline
                        check_guideline_instances(xilinx_occ_it, lw)

        if (len(lw) > 0):
            title_printed = False

            for message in lw:
                if (list_has_substring(modified_files, message)):
                    if (not title_printed):
                        print ("\n -> For %s in:" % file_name)
                        title_printed = True
                    guideline_ok = False
                    print(message)

    if (error_files):
        error_in_library = False

        for file in error_files:
            ## for files in /projects folder,
            ## the module - file name check doesn't matter
            if (file.find("library") != -1):
                error_in_library = True

        if (error_in_library):
            guideline_ok = False
            print ("Files with name errors:")
            for file in error_files:
                ## for files in /projects folder,
                ## the module - file name check doesn't matter
                if (file.find("library") != -1):
                    print (file)

    if (not guideline_ok):
        print("\nGUIDELINE RULES ARE NOT FOLLOWED\n")
        sys.exit(1)
    else:
        sys.exit(0)
