// first we need to create a stage
let cell_status = {
    FREE: 0,
    OCCUPIED: 1,
    START: 2,
    END: 3
}

class Brush{
    constructor(name, fill_color,cell_status){
        this.name= name;
        this.fill_color = fill_color;
        this.cell_status = cell_status;
    }

    paint(cell){
        cell.fill(this.fill_color)
        cell.status = this.cell_status
    }
};

brushes = [
    new Brush("wall",'#60a3e6',cell_status.OCCUPIED),
    new Brush("start",'#f90f0b',cell_status.START),
    new Brush("end",'#fdfc0d',cell_status.END),
    new Brush("eraser",'',cell_status.FREE),
]

isBrushing=false;

class Maze {
    constructor(n_rows, n_cols){
        this.ViewModel = {
            rows : ko.observable(5),
            cols : ko.observable(5),
            brushes : ko.observableArray(brushes),
            selected_brush: ko.observable(),
        }

        ko.applyBindings(this.ViewModel, document.getElementById("maze_params"))


        
        this.generate_maze()

    }

    generate_maze(rows,cols){
        this.stage = new Konva.Stage({
            container: 'maze_canvas',   // id of container <div>
            width:800,
            height:800
        });
        var cell_size = this.stage.height() / this.ViewModel.cols()
        this.cells_layer = new Konva.Layer();

        this.cells = []
        for (let i = 0; i < this.ViewModel.rows(); i++) {
            this.cells[i]=[]
            for (let j = 0; j < this.ViewModel.cols(); j++) {
                
                var cell = new Konva.Rect({
                    x: j*cell_size,
                    y: i*cell_size,
                    width: cell_size,
                    height: cell_size,
                    fill: '',
                    stroke: 'black',
                    strokeWidth: 4
                    });
                
                cell.status = cell_status.FREE //cell_status.FREE
        
                this.cells_layer.add(cell)
                this.cells[i].push(cell)        

                //UI events
                var self = this // self refers to maze object, this in event refers to cell
                cell.on('mousemove', function(evt){ //mousemove event generates unuseful events but catch the first cell to paint
                    
                    if(!isBrushing){
                        return;
                    }
                    // get selected brush and paint on maze
                    self.ViewModel.selected_brush().paint(evt.currentTarget)
                    self.cells_layer.draw();
                })
            }
        }     
        
        this.stage.on('mousedown', function(){
            isBrushing=true;
        })
        
        this.stage.on('mouseup', function(){
            isBrushing=false;
        })      
        
        // add the layer to the stage
        this.stage.add(this.cells_layer);
    }

    get_cell_status(row,col){
        return this.cells[row][col].status
    }
}



class MazeCompiler{

    constructor(){
        this.ViewModel = {
            rows_symbol : ko.observable("num_row"),
            cols_symbol : ko.observable("num_col"),
            position_symbol : ko.observable("pos"),
            occupied_symbol : ko.observable("occupied"),
            start_symbol : ko.observable("initial"),
            end_symbol : ko.observable("final")

        }
        ko.applyBindings(this.ViewModel,document.getElementById("prolog_params"))
    }
    

    get_rows_predicate(n_rows){
        return this.ViewModel.rows_symbol() + "(" + n_rows + ")";
    }

    get_cols_predicate(n_cols){
        return this.ViewModel.cols_symbol() + "(" + n_cols + ")";
    }

    get_position_predicate(row,col){
        return this.ViewModel.position_symbol() + "(" + row + "," + col + ")";
    }

    get_occupied_predicate(row,col){
        return this.ViewModel.occupied_symbol() + "(" + this.get_position_predicate(row,col) + ")";
    }

    get_start_predicate(row,col){
        return this.ViewModel.start_symbol() + "(" + this.get_position_predicate(row,col) + ")";
    }

    get_end_predicate(row,col){
        return this.ViewModel.end_symbol() + "(" + this.get_position_predicate(row,col) + ")";
    }

    write_statement(predicate){
        return predicate + ".\n"
    }

    compile(maze){
        // code to write prolog predicates
        var prolog_program = ""

        prolog_program += this.write_statement(this.get_rows_predicate(maze.ViewModel.rows()))
        prolog_program += this.write_statement(this.get_cols_predicate(maze.ViewModel.cols()))

        for (let i = 0; i < maze.ViewModel.rows(); i++) {
            for (let j = 0; j < maze.ViewModel.cols(); j++) {
                var row = i+1;
                var col = j+1;
                switch(maze.get_cell_status(i,j)){
                    case cell_status.OCCUPIED:
                        prolog_program += this.write_statement(this.get_occupied_predicate(row,col));
                        break;
                    case cell_status.START:
                        prolog_program += this.write_statement(this.get_start_predicate(row,col));
                        break;
                    case cell_status.END:
                        prolog_program += this.write_statement(this.get_end_predicate(row,col));
                        break;

                }
            } 
        }        
        return prolog_program
    }
}

maze_compiler = new MazeCompiler();

maze = new Maze(10,10);


function download_file(filename, data) {
    var blob = new Blob([data], {type: 'text/csv'});
    if(window.navigator.msSaveOrOpenBlob) {
        window.navigator.msSaveBlob(blob, filename);
    }
    else{
        var elem = window.document.createElement('a');
        elem.href = window.URL.createObjectURL(blob);
        elem.download = filename;        
        document.body.appendChild(elem);
        elem.click();        
        document.body.removeChild(elem);
    }
}

// UI EVENTS
document.getElementById("generate_code_btn").addEventListener('click',function (){

    prolog_code = maze_compiler.compile(maze)
    //chek if prolog code is shorter than 25 lines write directly to html otherwise download a file
    if (prolog_code.split(/\r\n|\r|\n/).length <= 25){ 
        document.getElementById('text_program').innerText = prolog_code;
    }
    else{
        document.getElementById('text_program').innerText = "";
        download_file("maze.pl",prolog_code);
    }
}); 

document.getElementById("generate_maze_btn").addEventListener('click',function (){

    maze.generate_maze()
}); 