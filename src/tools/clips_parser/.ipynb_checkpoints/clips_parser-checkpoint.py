import numpy as np
import matplotlib.pyplot as plt
import re


input_file = "test_output.txt"

heatmap = np.zeros(shape=(10,10))  # initializing the matrix
heatmap_median = np.zeros(shape=(10,10))

with open(input_file,"r") as file:
    lines = file.read()
    
    regex_heatmap = re.compile("heat-map \(x (\d)\) \(y (\d)\) \(h (\d+)\)")
    coordinates = re.findall(regex_heatmap, lines)
    
    for c in coordinates:
        x = int(c[0])
        y = int(c[1])
        value = int(c[2])
        heatmap[x,y] = value
        
        if value == 100:
            heatmap_median[x,y] = 6
        else:
            heatmap_median[x,y] = value
    
    print(heatmap)  # DEBUG
    print(heatmap_median)  # DEBUG
    
# Cmap reference https://matplotlib.org/3.1.1/gallery/color/colormap_reference.html
plt.imshow(heatmap, cmap="binary", interpolation='nearest')
plt.xlabel("Y (colonne)")
plt.ylabel("X (righe)")
plt.title("Valori a 100")
plt.show()

plt.imshow(heatmap_median, cmap="binary", interpolation='nearest')
plt.xlabel("Y (colonne)")
plt.ylabel("X (righe)")
plt.title("Mediana = 6")
plt.show()
