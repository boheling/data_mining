package DmDB::Rating;
use base qw{DBIx::Class};

__PACKAGE__->load_components(qw{ PK::Auto Core });

__PACKAGE__->table('rating');
__PACKAGE__->add_columns(
    qw/id user_id item_id rating/
);

__PACKAGE__->set_primary_key('id');
1;

package DmDB::Occupation;
use base qw{DBIx::Class};

__PACKAGE__->load_components(qw{ PK::Auto Core });

__PACKAGE__->table('occupation');
__PACKAGE__->add_columns(
    qw/occ_id occupation/
);

__PACKAGE__->set_primary_key('occ_id');
__PACKAGE__->add_unique_constraint( occupation => [qw{occupation}], );
1;

package DmDB::User;
use base qw{DBIx::Class};

__PACKAGE__->load_components(qw{ PK::Auto Core });

__PACKAGE__->table('user');
__PACKAGE__->add_columns(
    qw/user_id age gender occupation zip_code/
);

__PACKAGE__->set_primary_key('user_id');
1;

package DmDB::Item;
use base qw{DBIx::Class};

__PACKAGE__->load_components(qw{ PK::Auto Core });

__PACKAGE__->table('item');
__PACKAGE__->add_columns(
    qw/item_id movie_title release_date  video_release_date
       IMDb_URL _unknown _Action Adventure  Animation Children
       Comedy Crime Documentary Drama Fantasy Film_Noir Horror
       Musical Mystery Romance Sci_Fi Thriller War Western/
);

__PACKAGE__->set_primary_key('item_id');
1;

package DmDB::Test;
use base qw{DBIx::Class};

__PACKAGE__->load_components(qw{ PK::Auto Core });

__PACKAGE__->table('test');
__PACKAGE__->add_columns(
    qw/test_id user_id item_id/
);
__PACKAGE__->set_primary_key('test_id');
1;

package DmDB;
use base qw{DBIx::Class::Schema};

__PACKAGE__->register_class( 'rating',      'DmDB::Rating' );
__PACKAGE__->register_class( 'occupation',  'DmDB::Occupation' );
__PACKAGE__->register_class( 'user',        'DmDB::User' );
__PACKAGE__->register_class( 'item',        'DmDB::Item' );
__PACKAGE__->register_class( 'test',        'DmDB::Test' );

1;


