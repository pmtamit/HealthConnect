//
//  AgeView.m
//  HealthConnect
//
//  Created by John Nguyen on 2/28/15.
//  Copyright (c) 2015 John Nguyen. All rights reserved.
//

#import "AgeView.h"
#import "AgeCell.h"
@implementation AgeView

-(id)initWithFrame:(CGRect)frame data :(NSMutableArray*)data{
    if ((self = [super initWithFrame:frame])) {
        _data = data ;
        ageTableView = [[UITableView alloc] initWithFrame:CGRectMake(-20, 0, self.frame.size.width+20, self.frame.size.height)];
        ageTableView.delegate = self ;
        ageTableView.dataSource = self ;
        [ageTableView registerNib:[UINib nibWithNibName:@"AgeCell" bundle:nil] forCellReuseIdentifier:@"AgeCell"];
        ageTableView.allowsSelection = YES ;
        [self addSubview:ageTableView];
    }
    return self ;

}

#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AgeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AgeCell" forIndexPath:indexPath];
     cell.backgroundColor = [UIColor colorWithRed:0.0/255 green:108.0/255 blue:194.0/255 alpha:0.70];
    [cell setData:[_data objectAtIndex:indexPath.row]];
   cell._ageDelegate = self ;
    return cell;
    

}
-(void)kAgeDelegateClick:(UITableViewCell *)sender{
        NSIndexPath *cellPath = [ageTableView indexPathForCell:sender];

        if (__fageDelegate != nil && [__fageDelegate conformsToProtocol:@protocol(_FAgeDelegate)]) {
            if ([__fageDelegate respondsToSelector:@selector(fAgeDelegateClick:)]) {
                [__fageDelegate fAgeDelegateClick:[_data objectAtIndex:cellPath.row]];
            }
        }
}
@end
