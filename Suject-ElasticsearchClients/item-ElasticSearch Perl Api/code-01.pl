use Search::Elasticsearch;
# Round-robin between two nodes:
my $e1 = Search::Elasticsearch->new(
    nodes => [
       '192.168.11.73:9200',
       '192.168.11.74:9200',
       '192.168.11.75:9200',
       '192.168.11.76:9200',
       '192.168.11.77:9200'
    ]
    );

# Connect to cluster at 192.168.11.73:9200, sniff all nodes and round-robin between them:
my $e = Search::Elasticsearch->new(
    nodes    => '192.168.11.73:9200',
    cxn_pool => 'Sniff'
    );

# Index a document:
$e->index(
    index   => 'my_app',
    type    => 'blog_post',
    id      => 1,
    body    => {
        title   => 'Elasticsearch clients',
        content => 'Interesting content...',
        date    => '2013-09-24'
    }
    );

# Get the document:
my $doc = $e->get(
    index   => 'my_app',
    type    => 'blog_post',
    id      => 1
    );

# Search:
my $results = $e->search(
    index => 'my_app',
    body  => {
        query => {
            match => { title => 'elasticsearch' }
        }
    }
    );

# Cluster requests:
my $health      = $e->cluster->health;
my $state       = $e->cluster->state;

# Index requests:
$e->indices->create(index=>'my_index');
$e->indices->delete(index=>'my_index');
$e->indices->delete(index=>'my_app');

foreach $key (keys %$health)
{
    print "$key=>$health->{$key}\n";
}

# foreach $key (keys %$results)
# {
#     $value=$results->{$key};
#     if (ref($value) eq 'HASH') {
#         print "$key=>$value\n";
#         print "\t***********begin********* \n";
#         foreach $subkey (keys %$value){
#             print "\t$subkey=>$value->{$subkey}\n";
#         }
#         print "\t***********end********* \n";
#     }
#     else{
#         print "$key=>$value\n";
#     }
# }

foreach $key (keys %$state)
{
    $value=$state->{$key};
    if (ref($value) eq 'HASH') {
        print "$key=>$value\n";
        print "\t***********begin********* \n";
        foreach $subkey (keys %$value){
            $subvalue=$value->{$subkey};
            if (ref($subvalue) eq 'HASH') {
                print "$subkey=>$value->{$subkey}\n";
                print "\t\t***********sub_begin********* \n";
                 foreach $sub_subkey (keys %$subvalue){
                    print "\t\t$sub_subkey=>$subvalue->{$sub_subkey}\n";
                }
                print "\tt***********sub_end********* \n";
            }
            else{
                print "\t$subkey=>$value->{$subkey}\n";
            }
        }

        print "\t***********end********* \n";
    }
    else{
        print "$key=>$value\n";
    }
}