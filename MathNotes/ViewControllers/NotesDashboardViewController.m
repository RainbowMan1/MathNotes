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

@interface NotesDashboardViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *notes;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation NotesDashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self fetchNotes];
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchNotes) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (IBAction)logOut:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you Sure?"
                                                                       message:@"Do you want to log out?"
                                                                preferredStyle:(UIAlertControllerStyleActionSheet)];
        UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Log Out"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
            [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {}];
            
             SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *loginNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
            sceneDelegate.window.rootViewController = loginNavigationController;
        }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No"
      style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * _Nonnull action) {}];
    
    [yesAction setValue:[UIColor redColor] forKey:@"titleTextColor"];
        
        [alert addAction:cancelAction];
    [alert addAction:yesAction];
        [self presentViewController:alert animated:YES completion:^{}];
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
