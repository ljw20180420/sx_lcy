#!/usr/bin/env python

import unittest
import subprocess
from tempfile import mkstemp
import filecmp
import os
import shutil
import gzip
import pathlib

class TestGetSxCsvfileRef(unittest.TestCase):
    def setUp(self):
        self.csvfiles = [
            'test/test_get_sx_csvfile_ref/final_hgsgrna_libb_all_0811_NGG_scaffold_nor_G1.csv',
            'test/test_get_sx_csvfile_ref/final_hgsgrna_libb_all_0811_NGG_scaffold_nor_G2.csv',
            'test/test_get_sx_csvfile_ref/final_hgsgrna_libb_all_0811_NGG_scaffold_nor_G3.csv',
            'test/test_get_sx_csvfile_ref/final_hgsgrna_libb_all_0811_NAA_scaffold_nbt_A1.csv',
            'test/test_get_sx_csvfile_ref/final_hgsgrna_libb_all_0811_NAA_scaffold_nbt_A2.csv',
            'test/test_get_sx_csvfile_ref/final_hgsgrna_libb_all_0811_NAA_scaffold_nbt_A3.csv'
        ]

        self.ref_files = [
            mkstemp(dir='test/test_get_sx_csvfile_ref', suffix='.ref')[1]
            for _ in self.csvfiles
        ]

        # Uncompress genome.fa.gz if it is not uncompressed yet.
        if not os.path.exists('test/genome/genome.fa'):
            with gzip.open('test/genome/genome.fa.gz', 'rb') as f_in, open('test/genome/genome.fa', 'wb') as f_out:
                shutil.copyfileobj(f_in, f_out)
            # Touch genome.fa.fai so that getfasta will not regenerate it.
            pathlib.Path.touch('test/genome/genome.fa.fai')

    def test_get_sx_csvfile_ref(self):
        for csvfile, ref_file in zip(self.csvfiles, self.ref_files):
            subprocess.run(
                f'''getSxCsvFileRef.md {csvfile} test/genome/genome.fa test/genome/genome 50 0 10 100 > {ref_file}''',
                shell=True,
                executable='/bin/bash'
            )
            self.assertTrue(
                filecmp.cmp(
                    ref_file,
                    f'{csvfile}.ref',
                    shallow=False
                )
            )

    def tearDown(self):
        for ref_file in self.ref_files:
            os.remove(ref_file)

if __name__ == '__main__':
    unittest.main()