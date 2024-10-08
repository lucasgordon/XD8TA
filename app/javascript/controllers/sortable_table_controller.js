import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sortable-table"
export default class extends Controller {
  static targets = ["table"]

  sortRowsByColumn(event) {
    const column = event.currentTarget.cellIndex;
    let rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
    const table = this.tableTarget;
    switching = true;
    // Set the sorting direction to ascending:
    dir = "asc";
    // Make a loop that will continue until no switching has been done:
    while (switching) {
      switching = false;
      rows = table.rows;
      // Loop through all table rows (except the first, which contains table headers):
      for (i = 1; i < (rows.length - 1); i++) {
        shouldSwitch = false;
        // Get the two elements you want to compare, one from current row and one from the next:
        x = rows[i].getElementsByTagName("TD")[column];
        y = rows[i + 1].getElementsByTagName("TD")[column];
        // Check if the two rows should switch place, based on the direction, asc or desc:
        if (dir == "asc") {
          if (Number(x.innerHTML.toLowerCase()) > Number(y.innerHTML.toLowerCase())) {
            // If so, mark as a switch and break the loop:
            shouldSwitch = true;
            break;
          }
        } else if (dir == "desc") {
          if (Number(x.innerHTML.toLowerCase()) < Number(y.innerHTML.toLowerCase())) {
            shouldSwitch = true;
            break;
          }
        }
      }
      if (shouldSwitch) {
        // If a switch has been marked, make the switch and mark that a switch has been done:
        rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
        switching = true;
        switchcount++;
      } else {
        // If no switching has been done AND the direction is "asc",
        // set the direction to "desc" and run the while loop again.
        if (switchcount == 0 && dir == "asc") {
          dir = "desc";
          switching = true;
        }
      }
    }
  }
}