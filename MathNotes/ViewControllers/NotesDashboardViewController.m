//
//  NotesDashboardViewController.m
//  MathNotes
//
//  Created by Nikesh Subedi on 7/13/20.
//  Copyright © 2020 Nikesh Subedi. All rights reserved.
//

#import "NotesDashboardViewController.h"
#import "Parse/Parse.h"
#import "NoteCell.h"
#import "SceneDelegate.h"
#import "NotesEditorViewController.h"
#import "ZSSDemoViewController.h"
@import SideMenu;

@interface NotesDashboardViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *notes;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation NotesDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpSideMenu];
    
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self fetchNotes];
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchNotes) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    
    
}

- (void)setUpSideMenu{
    SideMenuManager.defaultManager.leftMenuNavigationController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuNavigationController"];
    [SideMenuManager.defaultManager addPanGestureToPresentToView:self.navigationController.navigationBar];
    [SideMenuManager.defaultManager addScreenEdgePanGesturesToPresentToView:self.tableView forMenu:PresentDirectionLeft];
}

- (void)fetchNotes {
    PFQuery *query = [PFQuery queryWithClassName:@"Notes"];
    [query orderByDescending:@"updatedAt"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
        // fetch data asynchronously
        [query findObjectsInBackgroundWithBlock:^(NSArray *notesArray, NSError *error) {
            if (notesArray != nil) {
                self.notes = notesArray;
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            } else {
            }
        }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteCell" forIndexPath:indexPath];
    cell.note = self.notes[indexPath.row];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"NewNote"]){
        NotesEditorViewController *noteEditor = [segue destinationViewController];
        noteEditor.note = [Note new];
        noteEditor.note.noteName = @"Untitled Note";
    }
    else if ([segue.identifier isEqualToString:@"EditNote"]){
        NotesEditorViewController *noteEditor = [segue destinationViewController];
        NoteCell *selectedcell = (NoteCell*) sender;
        NSLog(@"%@",selectedcell.note.htmlText);
        noteEditor.note = selectedcell.note;
    }
}

@end