<?php

class Test
 {
	protected function test()
	{
		glob('data/*.txt');  // PROBLEM
	}
    
	/**
	 * @return bool
	 */
	public function test2()
	{
		
	}
}