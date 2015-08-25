module IRCd
  VERSION = "0.0.1"
  BuildDate = {{ `date -u`.stringify.chomp }}
  BuildYear = {{ `date +%Y`.stringify.chomp.id }}
  Copyright = "Copyright (C) 2015" + (BuildYear > 2015 ? " - " + BuildYear.to_s : "") + " Stephan Henrichs"
end
