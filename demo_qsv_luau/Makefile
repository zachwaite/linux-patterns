.PHONY: splitname
splitname:
	rm -f ./qsv_rCURRENT.log
	qsv luau map First,Last file:scripts/splitname.lua odoo_sales.csv

.PHONY: running_total
running_total:
	rm -f ./qsv_rCURRENT.log
	< odoo_sales.csv qsv sort -s 'Order Date' \
		| qsv luau map 'Running Total' file:/scripts/running_total.lua

.PHONY: moving_average
moving_average:
	rm -f ./qsv_rCURRENT.log
	< odoo_sales.csv qsv sort -s 'Order Date' \
		| qsv luau map 'Moving Average' file:scripts/moving_average.lua
