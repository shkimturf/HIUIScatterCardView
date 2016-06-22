# HIUIScatterCardView

It shows scattered cards on large board. You can scroll any direction to see them. It supports zooming and fetching more contents with expanding board.

## Screenshot

![alt tag](https://github.com/shkimturf/HIUIScatterCardView/blob/master/preview.gif?raw=true)

## Environments

over iOS 7.0

## Usage

### Setup

Just import **HIUIScatterCardView** source files to your project.

### Layout Manager

* Cell means the rect which contains tile to show. Should return cell size for drawing tiles.
* Tile is actually grid view to show. 
* initialPanelLevel means radius of initial panel size.
** | cell | cell | center cell | cell | cell |
** Above initial level is *2*

``` objc
    CGSize cellSize;
    CGSize tileSize;
    NSUInteger initialPanelLevel;
```

### DataSource

It likes **UITableViewDataSource**.
* Tile should conform HIUIScatterCardTile protocol. 

There is some kinds of methods to fetch data or transform tile to show.

``` objc
    - (NSInteger)numberOfDataInScatterCardView:(HIUIScatterCardView*)scatterCardView;
    - (UIView<HIUIScatterCardTile>*)scatterCardView:(HIUIScatterCardView*)scatterCardView tileAtIndexPath:(NSIndexPath*)indexPath;
    - (BOOL)canFetchMoreInScatterCardView:(HIUIScatterCardView*)scatterCardView;
    - (void)scatterCardView:(HIUIScatterCardView *)scatterCardView shouldFetchDataWithDirection:(HIUIScatterCardViewExpandDirection)direction;

    @optional
    - (void)scatterCardView:(HIUIScatterCardView*)scatterCardView transformTile:(UIView<HIUIScatterCardTile>*)tile atIndexPath:(NSIndexPath*)indexPath;
```

### Delegate

Supports some kinds of delegate functions.

``` objc
    - (void)scatterCardView:(HIUIScatterCardView*)scatterCardView didSelectTileAtIndexPath:(NSIndexPath*)indexPath;
    - (void)scatterCardView:(HIUIScatterCardView*)scatterCardView didExpandedWithCellCount:(NSInteger)numberOfCurrentCells;
```

## Sample source

**HIUIScatterCardView** implements explained above and shows how to use this library.

## Author

[shkimturf](https://github.com/shkimturf)

## License

HIUIScatterCardView is under MIT License.