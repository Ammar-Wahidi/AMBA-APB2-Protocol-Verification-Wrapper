//Ammar Ahmed Wahidi
package APB_monitor_pkg;
import APB_sequence_item_pkg ::*;
import APB_scoreboard_pkg ::*;
import APB_coverage_pkg ::*;
class APB_monitor ;

APB_scoreboard monitor_scoreboard = new();
APB_coverage   cvr = new();

task monitor (APB_sequence_item values);
monitor_scoreboard.scoreboard(values);
cvr.sample_data(values);

endtask
endclass
endpackage 