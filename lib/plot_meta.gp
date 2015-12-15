set terminal png 
set xlabel 'Experimental'
set ylabel 'Theta'
set title 'Meta Line Chart'
set output 'meta_line_chart.png'
plot '../../resource/_tmp_meta_plot.dat' using 1:xtic(2) with linespoints
set output
