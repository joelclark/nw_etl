TABLES=orders

DATE=$(shell date +%Y%m%d)
SPOOL_DIR=var/work/$(DATE)
UNLOAD_DIR=$(SPOOL_DIR)/unload
ARCHIVE_DIR=var/archive/$(shell date +%Y%m)
ARCHIVE_FILE=$(ARCHIVE_DIR)/etl-$(DATE).tar.gz
PSQL=psql nw_stage

.PHONY: clean all
.SECONDARY:

all: $(ARCHIVE_FILE)

clean: ddl
	rm -rf $(SPOOL_DIR) $(ARCHIVE_FILE)

reset-ddl:
	$(PSQL) -c "DROP SCHEMA IF EXISTS unload CASCADE"
	$(PSQL) -c "CREATE SCHEMA unload"

$(ARCHIVE_FILE): $(SPOOL_DIR)/unload.completed
	mkdir -p $(ARCHIVE_DIR)
	tar cvpfz $(ARCHIVE_FILE) $(SPOOL_DIR)

$(SPOOL_DIR)/unload.completed: $(TABLES)
	touch $(SPOOL_DIR)/unload.completed

$(TABLES): %: $(SPOOL_DIR)/%.loaded

$(SPOOL_DIR)/%.loaded: $(UNLOAD_DIR)/%.csv
	bin/pg-load-csv $(notdir $<) $< 
	touch $@

$(UNLOAD_DIR)/%.csv: 
	mkdir -p $(UNLOAD_DIR)
	bin/mysql-csv-out < sql/$(notdir $@.sql) > $@.tmp
	mv $@.tmp $@

