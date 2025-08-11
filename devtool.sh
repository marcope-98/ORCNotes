#!/bin/bash
# colleen hoover All your perfects Un ricordo ti parlera di noi

function dvt(){
    command="$(echo "$1" | tr '[:upper:]' '[:lower:]')"
    case $command in
        clean)
            rm -rf build
            ;;
        build)
            dvt pre
            dvt latexmk
            dvt biber
            dvt makeglossaries
            dvt latexmk
            ;;
        pre)
            mkdir -p build/chapters build/lib
            ;;
        latexmk)
            latexmk --shell-escape -synctex=1 -interaction=nonstopmode -file-line-error -output-directory=build main 
            ;;
        biber)
            biber --input-directory build --output-directory build main
            ;;
        makeglossaries)
            makeglossaries -d build main
            ;;
        shortlist)
            echo clear build pre latexmk biber makeglossaries
            ;;
        *)
            echo "Available commands"
            echo ""
            echo -e "\t dvt clean          : cleans auxiliary files"
            echo -e "\t dvt build          : runs complete pipeline"
            echo -e "\t dvt pre            : sets up build folder structure"
            echo -e "\t dvt latexmk        : runs latexmk and generates pdf"
            echo -e "\t dvt biber          : runs biber to add bibliography"
            echo -e "\t dvt makeglossaries : runs makeglossaries to add acronyms"
        ;;  
    esac
}

function _dvt() {
    local AVAILABLE_COMMANDS=$(dvt shortlist)
    COMPREPLY=()
    if [ "$COMP_CWORD" -eq 1 ] ; then
        local cur=${COMP_WORDS[COMP_CWORD]}
        COMPREPLY=($( compgen -W "$AVAILABLE_COMMANDS" -- $cur ))
    fi
}

complete -o nospace -F _dvt dvt