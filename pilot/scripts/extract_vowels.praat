writeInfoLine: "Extracting formants..."

# Extract the names of the Praat objects
thisSound$ = selected$("Sound")
thisTextGrid$ = selected$("TextGrid")

# Extract the number of intervals in the phoneme tier
select TextGrid 'thisTextGrid$'
numberOfPhonemes = Get number of intervals: 2  
appendInfoLine: "There are ", numberOfPhonemes, " intervals."

# Create the Formant Object
select Sound 'thisSound$'
To Formant (burg)... 0 5 5000 0.025 50

# Create the output file and write the first line.
outputPath$ = "~/Desktop/Tatar/pilot/measurements/"+thisSound$+".csv"
writeFileLine: "'outputPath$'", "file,time,word,phoneme,F1,F2,F3"

# Loop through each interval on the phoneme tier.
for thisInterval from 1 to numberOfPhonemes
    #appendInfoLine: thisInterval

    # Get the label of the interval
    select TextGrid 'thisTextGrid$'
    thisPhoneme$ = Get label of interval: 2, thisInterval
    #appendInfoLine: thisPhoneme$
    
    # Find the midpoint.
    thisPhonemeStartTime = Get start point: 2, thisInterval
    thisPhonemeEndTime   = Get end point:   2, thisInterval
    duration = thisPhonemeEndTime - thisPhonemeStartTime
    midpoint = thisPhonemeStartTime + duration/2
    
    # Extract formant measurements
    select Formant 'thisSound$'
    f1 = Get value at time... 1 midpoint Hertz Linear
    f2 = Get value at time... 2 midpoint Hertz Linear
    f3 = Get value at time... 3 midpoint Hertz Linear

    # Get the word interval and then the label
    select TextGrid 'thisTextGrid$'
    thisWordInterval = Get interval at time: 1, midpoint
    thisWord$ = Get label of interval: 1, thisWordInterval

    # Save to a spreadsheet
    appendFileLine: "'outputPath$'", 
		    ...thisSound$, ",",
		    ...midpoint, ",",
		    ...thisWord$, ",",
		    ...thisPhoneme$, ",",
		    ...f1, ",", 
		    ...f2, ",", 
		    ...f3

endfor

appendInfoLine: newline$, newline$, "Whoo-hoo! It didn't crash!"