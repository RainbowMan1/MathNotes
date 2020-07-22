//
//  EquationSnipDashboardViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "EquationSnipDashboardViewController.h"
#import "EquationSnip.h"
#import "EquationSnipCell.h"
#import "EquationSnipsDetailViewController.h"

@interface EquationSnipDashboardViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray *equationSnips;
@end

@implementation EquationSnipDashboardViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchEquationSnips) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView addSubview:self.refreshControl];
       NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    
    [self fetchEquationSnips];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)fetchEquationSnips{
    PFQuery *query = [PFQuery queryWithClassName:@"EquationSnips"];
       [query orderByDescending:@"updatedAt"];
       [query whereKey:@"author" equalTo:[PFUser currentUser]];
           // fetch data asynchronously
           [query findObjectsInBackgroundWithBlock:^(NSArray *equationsArray, NSError *error) {
               if (equationsArray != nil) {
                   self.equationSnips = equationsArray;
                   [self.tableView reloadData];
                   [self.refreshControl endRefreshing];
               } else {
               }
           }];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.equationSnips.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EquationSnipCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EquationSnipCell" forIndexPath:indexPath];
    cell.equationSnip = self.equationSnips[indexPath.row];
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"EquationDetail"]) {
        EquationSnipCell *selectedCell = (EquationSnipCell*) sender;
        EquationSnipsDetailViewController *destination = [segue destinationViewController];
        destination.equationSnip = selectedCell.equationSnip;
    }
}

@end
