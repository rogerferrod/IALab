# Timetable Maker - Clingo Transpiler

A simple Clingo transpiler script that produces an Excel timetable. It takes as input a ```.txt``` file containing the clingo output, and it returns a ```.xlsx``` file containing the timetable rapresentation of the input.

## Usage

In order to improve readability, we'll use the following shortening:

- ```input path```: path to the .txt file containing the Clingo output,
- ```output path```: path to the output folder in which put the .xlsx file.

```python
python3 clingo_transpiler.py -i <input path> -o <output path>
```

## Note

This parser doesn't just save the output in excel, but it also leaves the user the possibility to define conditional highlighting constraints.

Here is an example:

```python
# Format 1. Light red fill with dark red text.
format1 = workbook.add_format({'bg_color': '#FFC7CE','font_color': '#9C0006'})

worksheet.conditional_format('C4:J59', {'type': 'text',
                                            'criteria': 'containing',
                                            'value': 'Recupero',
                                            'format': format1})
```
