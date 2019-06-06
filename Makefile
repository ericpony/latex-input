MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

latex_data_dir := data/latex
latex_data_files := $(wildcard $(latex_data_dir)/*)
latex_targets := latex.el latex.cin latex.txt latex.ahk latex.stats.txt latex.inputplugin latex.exe

latex.el: $(latex_data_files)
	./generate.rb --name LaTeX --emacs-lisp-file=$@ $^

latex.cin: $(latex_data_files)
	./generate.rb --name LaTeX --cin-file=$@ $^

latex.inputplugin: $(latex_data_files)
	./generate.rb --name LaTeX --inputplugin-file=$@.tmp $^
	iconv -f utf-8 -t utf-16 < $@.tmp > $@
	rm $@.tmp

latex.txt: $(latex_data_files)
	./generate.rb --name LaTeX --ibus-file=$@ $^

latex.ahk: $(latex_data_files)
	./generate.rb --name LaTeX --autohotkey-file=$@ $^

latex.exe: $(latex_data_files)
	[[ -f latex.ahk ]] && ./ahk-to-exe/Ahk2Exe.exe //in latex.ahk //out latex.exe

latex.stats.txt: $(latex_data_files)
	./generate.rb --stats-file=$@ $^

apl_data_dir := data/apl
apl_data_files := $(wildcard $(apl_data_dir)/*)
apl_targets := apl/apl.el apl/apl.cin apl/apl.ahk apl/apl.stats.txt apl/apl.inputplugin

apl/apl.el: $(apl_data_files)
	./generate.rb --name APL --emacs-lisp-file=$@ $^

apl/apl.cin: $(apl_data_files)
	./generate.rb --name APL --cin-file=$@ $^

apl/apl.inputplugin: $(apl_data_files)
	./generate.rb --name APL --inputplugin-file=$@.tmp $^
	iconv -f utf-8 -t utf-16 < $@.tmp > $@
	rm $@.tmp

apl/apl.ahk: $(apl_data_files)
	./generate.rb --name APL --autohotkey-file=$@ $^

apl/apl.stats.txt: $(apl_data_files)
	./generate.rb --stats-file=$@ $^

latex_apl_data_files := $(wildcard $(latex_data_dir)/*) $(wildcard $(apl_data_dir)/*)
latex_apl_targets := apl/latex_apl.el apl/latex_apl.cin apl/latex_apl.ahk apl/latex_apl.stats.txt apl/latex_apl.inputplugin

apl/latex_apl.el: $(latex_apl_data_files)
	./generate.rb --name LaTeX/APL --emacs-lisp-file=$@ $^

apl/latex_apl.cin: $(latex_apl_data_files)
	./generate.rb --name LaTeX/APL --cin-file=$@ $^

apl/latex_apl.inputplugin: $(latex_apl_data_files)
	./generate.rb --name LaTeX/APL --inputplugin-file=$@.tmp $^
	iconv -f utf-8 -t utf-16 < $@.tmp > $@
	rm $@.tmp

apl/latex_apl.ahk: $(latex_apl_data_files)
	./generate.rb --name LaTeX/APL --autohotkey-file=$@ $^

apl/latex_apl.stats.txt: $(latex_apl_data_files)
	./generate.rb --stats-file=$@ $^

targets := $(latex_targets) #$(apl_targets) $(latex_apl_targets)

.PHONY: all
all: $(targets)

.PHONY: clean
clean:
	rm $(targets)
