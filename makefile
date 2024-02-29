# Usually, only these lines need changing
# QPAPFILE = Tax-Prod
QSLIFOLD = Slides
QPDFFOLD = Notes
TIKZFOLD = Slides/figures
# RDIR = ./Code/Colombia
# QPAPDIR = ./Paper
# QSLIDIR = ./Quarto-Slides

# list all R files
QSLIFILES := $(wildcard $(QSLIFOLD)/*.qmd)
QPDFFILES := $(wildcard $(QPDFFOLD)/*.qmd)
TIKZFILES := $(wildcard $(TIKZFOLD)/*.tex)
# RFILES := $(wildcard $(RDIR)/*.R)
# EXCLUDE := $(wildcard $(RDIR)/_*.R)
# QFILES := $(wildcard $(QPAPDIR)/*.qmd)
# QEXCLUDE := $(wildcard $(QPAPDIR)/_*.qmd)
# RDEP := $(wildcard $(RDIR)/*beta_diff.R)

# excluding files that start with "_" during development
# RFILES := $(filter-out $(EXCLUDE),$(RFILES))
# QFILES := $(filter-out $(QEXCLUDE),$(QPAPFILES))
# QFILES := $(filter-out $(QPAPFILE).qmd,$(QPAPFILES))
# RIND := $(filter-out $(RDEP),$(RFILES))


# Indicator files to show R file has run
# OUT_FILES := $(RFILES:.R=.Rout)
# RDEPOUT := $(RIND:.R=.Rout)
Q_SLI_OUT_FILES := $(QSLIFILES:.qmd=.html)
Q_PDF_OUT_FILES := $(QPDFFILES:.qmd=.pdf)
PDF_FIGS := $(TIKZFILES: .tex=.pdf)
PNG_FROM_PDF_FIGS := $(TIKZFILES: .tex=.png)
# Targets
## Default target
main: $(RDIR)/main.Rout #$(filter-out $(RDIR)/main.Rout, $(OUT_FILES))

## Make all
all: slides pdfs

## Run R files
R: $(OUT_FILES)

## Make paper
paper: #$(QPAPDIR)/$(QPAPFILE).pdf
	quarto render $(QPAPDIR)/$(QPAPFILE).qmd 
#	quarto render $(QPAPDIR)/$(QPAPFILE).qmd --to pdf -M include-in-header:packages.tex
#	open -a Preview $(QPAPDIR)/$(QPAPFILE).pdf
pdf:
	quarto render $(QPAPDIR)/$(QPAPFILE).qmd --to pdf -M include-in-header:_extensions/quarto-journals/jasa/packages.tex

html:
	quarto render $(QPAPDIR)/$(QPAPFILE).qmd --to html
#
# Make slides
slides: $(Q_SLI_OUT_FILES) $(PNG_FROM_PDF_FIGS) $(PDF_FIGS)
#	quarto render $(QSLIDIR)/$(QSLIFILE).qmd
#	open -a Safari $(QSLIDIR)/$(QSLIFILE).html
# Make pdfs
pdfs: $(Q_PDF_OUT_FILES) 

# Rules
# $(RDIR)/%.Rout: $(RDIR)/%.R 
# 	R CMD BATCH --no-save --no-restore-data $< $@

$(TIKZFOLD)/%.pdf: $(TIKZFOLD)/%.tex
	pdflatex $<

$(TIKZFOLD)/%.png: $(TIKZFOLD)/%.pdf
	convert -density 600 $< $@

# # # Compile main tex file and show errors
# $(QPAPDIR)/$(QPAPFILE).pdf: $(QPAPDIR)/$(QPAPFILE).qmd #$(QFILES) #$(OUT_FILES) #$(CROP_FILES)
# 	quarto preview $<

$(QSLIFOLD)/%.html: $(QSLIFOLD)/%.qmd 
	quarto render $<

$(QPDFFOLD)/%.pdf: $(QPDFFOLD)/%.qmd
	quarto render $<
# # Compile main tex file and show errors
# $(QSLIFILE).html: $(QSLIFILE).qmd $(OUT_FILES) #$(CROP_FILES)
#     quarto preview "$(QSLIDIR)/$(QSLIFILE).qmd"

# Dependencies
# May need to add something here if some R files depend on others.
$(RDIR)/main.Rout: $(RFILES)

# $(QSLIFOLD)/04-market-structure-competition.html: $(PNG_FROM_PDF_FIGS) $(PDF_FIGS)

# $(Q_SLI_OUT_FILES): $(TIKZFOLD)/$(PNG_FROM_PDF_FIGS)

# $(PNG_FROM_PDF_FIGS): $(PDF_FIGS)
# $(RDIR)/30_beta_diff.Rout $(RDIR)/40_beta_diff_yoy.Rout $(RDIR)/45_beta_diff.Rout :$(RDIR)/20_functions.R $(RDIR)/15_global_vars.R $(RDIR)/00_reading_data.R

# $(RDIR)/60_plot_discontinuity.Rout $(RDIR)/50_beta_diff.Rout $(RDIR)/30_beta_diff.Rout:$(RDIR)/20_functions.R $(RDIR)/15_global_vars.R $(RDIR)/00_reading_data.R

# $(RDEPOUT) : $(RIND)


# Clean up stray files
clean:
	rm -fv $(OUT_FILES) 
	rm -fv *.Rout *.RData
	rm -fv *.aux *.log *.toc *.blg *.bbl *.synctex.gz *.out *.bcf *blx.bib *.run.xml
	rm -fv *.fdb_latexmk *.fls
#	rm -fv $(TEXFILE).pdf
clean-out:
	rm -fv $(OUT_FILES) *.Rout

clean-tex:
	rm -fv Paper/*.aux Paper/*.log Paper/*.toc Paper/*.blg Paper/*.bbl Paper/*.synctex.gz
	rm -fv Paper/*.fdb_latexmk Paper/*.fls

clean-html:
	rm -fv *.html

.PHONY: all clean paper slides clean-tex clean-out