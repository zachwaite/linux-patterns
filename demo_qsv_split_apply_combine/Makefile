.PHONY: clean
clean:
	rm -rf diamonds_by_cut/

.PHONY: split
split:
	qsv partition 'cut' diamonds_by_cut diamonds.csv

.PHONY: apply
apply:
	# mean price by cut
	find diamonds_by_cut/ -name '*.csv' | parallel "./filestats {} diamonds_by_cut"

.PHONY: combine
combine:
	qsv cat rows diamonds_by_cut/*_mean.csv | qsv table
