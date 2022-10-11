use filesystem::db::FilesDatabase;
use parser::test_utils::{get_syntax_root_and_diagnostics, read_file, ParserDatabaseForTesting};
use pretty_assertions::assert_eq;
use syntax::node::db::SyntaxDatabase;
use test_case::test_case;

use crate::{get_formatted_file, FormatterConfig};

#[salsa::database(SyntaxDatabase, FilesDatabase)]
#[derive(Default)]
pub struct DatabaseImpl {
    storage: salsa::Storage<DatabaseImpl>,
}
impl salsa::Database for DatabaseImpl {}

// TODO(Gil): Add tests
#[test_case("test_data/cairo_files/test1.cairo", "test_data/expected_results/test1.cairo")]
#[test_case(
    "test_data/cairo_files/linebreaking.cairo",
    "test_data/expected_results/linebreaking.cairo"
)]
fn format_and_compare_file(unformatted_filename: &str, expected_filename: &str) {
    let db_val = ParserDatabaseForTesting::default();
    let db = &db_val;

    let (syntax_root, diagnostics) = get_syntax_root_and_diagnostics(db, unformatted_filename);
    diagnostics.expect("A parsing error occured while trying to format the code.");
    let config = FormatterConfig::default();
    let formatted_file = get_formatted_file(db, &syntax_root, config);
    let expected_file = read_file(expected_filename);
    assert_eq!(formatted_file, expected_file);
}