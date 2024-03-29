# Alexander Scott

tsv = list()
used_dates = list()
out = open("outtex.txt", "w")
hline = r"\hline"

# Read out.txt
with open("./out.txt") as f:
    content = f.readlines()

# Add lines to array
# This is an array of subarrays organized by date
# that containt arrays of lines split by tabs
for line in content:
	if line.split("\t")[0] not in used_dates:
		used_dates.append(line.split("\t")[0])
		tsv.append(list())    
	tsv[-1].append(line.split("\t"))

# Get start and end dates
first = tsv[0][0][0]
last = tsv[len(tsv) - 1][0][0]

# Write beginning of document
l = r"\documentclass{article}"
out.write(l)
out.write("\n")
l = r"\usepackage[utf8]{inputenc}"
out.write(l)
out.write("\n")
l = r"\usepackage{array}"
out.write(l)
out.write("\n")
l = r"\newcolumntype{L}{>{\centering\arraybackslash}m{3cm}}"
out.write(l)
out.write("\n")
l = r"\title{UMUCTV schedule from " + first + " to " + last + "}\n"
out.write(l)
l = r"\begin{document}"
out.write(l)
out.write("\n")
l = r"\maketitle"
out.write(l)
out.write("\n")
l = r"\newpage"
out.write(l)
out.write("\n")
l = r"\begin{table}[h]"
out.write(l)
out.write("\n")
l = r"\begin{tabular}{|c|c|L|L|}"
out.write(l)
out.write("\n")
out.write(hline)
out.write("\n")
l = r"Time & Date & Show & Series \\"
out.write(l)
out.write("\n")
out.write(hline)
out.write("\n")

# Write all the data to file
count = 1
for i in tsv:
	for j in i:
		count = count + 1
		l = r"" + j[1] + " & " + j[0] + " & " + j[3] + " & " + j[4] + r"\\"
		out.write(l)
		out.write("\n")
		out.write(hline)
		out.write("\n")
		if count == 20:
			count = 1
			l = r"\end{tabular}"
			out.write(l)
			out.write("\n")
			l = r"\end{table}"
			out.write(l)
			out.write("\n")
			l = r"\newpage"
			out.write(l)
			out.write("\n")
			l = r"\begin{table}[hp]"
			out.write(l)
			out.write("\n")
			l = r"\begin{tabular}{|c|c|L|L|}"
			out.write(l)
			out.write("\n")
			out.write(hline)
			out.write("\n")
			l = r"Time & Date & Show & Series \\"
			out.write(l)
			out.write("\n")
			out.write(hline)
			out.write("\n")

# Write end of document
l = r"\end{tabular}"
out.write(l)
out.write("\n")
l = r"\end{table}"
out.write(l)
out.write("\n")
l = r"\end{document}"
out.write(l)
