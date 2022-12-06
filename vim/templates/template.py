#!/usr/bin/env python

"""
Author:  <uid>

A description which can be long and explain the complete
functionality of this module even with indented code examples.
Class/Function however should not be documented here.
"""

from __future__ import print_function
import argparse

def parse_args():
    """
    Create command line parser

    :return: the arguments
    :rtype: parser.parse_args()
    """
    desc = __import__('__main__').__doc__
    parser = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        description=desc)
    parser.add_argument('-f', '--filename', 
                        type=argparse.FileType('r', encoding='utf-8'))
    parser.add_argument('-t', '--doctest', action='store_true',
                        help='Run doctest')
    parser.add_argument('-v', '--verbose', action='store_true',
                        default=True, help='Verbose')
    return parser.parse_args()

if __name__ == '__main__':
    args = parse_args()
