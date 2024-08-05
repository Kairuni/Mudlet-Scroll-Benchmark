SCROLL_BENCHMARK = SCROLL_BENCHMARK or {};
local sb = SCROLL_BENCHMARK;

-- Never actually used raw, but for reference.
sb.options = {
  stepSize = 10,
  length = 10000,
};

-- Tracking variables for the run.
sb.startTime = 0;
sb.endTime = 0;
sb.lineCount = 0;
sb.running = false;
sb.startTimer = nil;

function sb.displayResults()
  local delta = sb.endTime - sb.startTime;
  local stepSize = sb.options.stepSize;
  local length = sb.options.length;
  
  cecho("<green>Benchmark complete.\n");
  echo("\n");
  cecho(f"<green>Processed <orange>{length}<green> scroll function calls.\n");
  cecho(f"<green>Scrolled with a step size of <orange>{stepSize}<green> lines.\n");
  echo("\n");
  cecho(f"<green>Completed the benchmark in <orange>{delta}<green> seconds.<reset>\n");
end

function sb.scrollBufferDown()
  local stepSize = sb.options.stepSize;
  
  scrollDown(stepSize);
  sb.lineCount = sb.lineCount - stepSize;
  selectCurrentLine();

  if (sb.lineCount <= 0) then
    sb.endTime = getEpoch();
    tempTimer(0, sb.displayResults);
  else
    tempTimer(0, sb.scrollBufferDown);
  end
end

function sb.scrollBufferUp()
  if (not sb.running) then
    cecho("<red>ABORTED SCROLL BENCHMARK<reset>\n");
    return;
  end
  
  local stepSize = sb.options.stepSize;
  local lineCount = sb.lineCount;

  if (lineCount < sb.options.length) then
    scrollUp(stepSize)
    sb.lineCount = lineCount + stepSize;
    selectCurrentLine();
    tempTimer(0, sb.scrollBufferUp);
  else
    tempTimer(0, sb.scrollBufferDown);
  end
end

local function startRun()
  if (sb.running) then
    -- This should run a for loop that prevents the thread from progressing, so we'll move straight in afterwards.
    Stressinator.runStress(sb.options.length);
    
    -- Ensure we're at the bottom.
    scrollDown(sb.options.length);
    -- Display this string after the Stressinator one.
    tempTimer(0, function()
      cecho("\n\n<green>Starting scroll test. The alias '<orange>STOPSCROLL<green>' will abort the run.<reset>\n");
    end);
    sb.timer = nil;
    sb.startTime = getEpoch();
    sb.lineCount = 0;
    
    sb.scrollBufferUp();
  else
    cecho("<red>ABORTED SCROLL BENCHMARK<reset>\n");
  end
end

function sb.start(options)
  options = options or {};
  options.stepSize = options.stepSize and tonumber(options.stepSize) or 10;
  -- TODO: 
  options.length = options.length and tonumber(options.length) or 10000;
  
  -- Just persist the options on the table, for now.
  SCROLL_BENCHMARK.options = options;
  
  -- Check for stressinator.
  if (not Stressinator) then
    cecho("<red>STRESSINATOR NOT DETECTED<reset> - This expects to be run after a stressinator run. Inconsistent buffer size will result in inconsistent results.\n");
  else
    cecho(f"\n<green>Starting scroll test with a stressinator run, starting in <b><yellow>5<green></b> seconds. Your buffer is going to flood with <b><red>{options.length}</b><green> lines, then scroll at a step of <b><red>{options.stepSize}</b><green> lines per step. Use the alias '<orange>STOPSCROLL<green>' to stop it\n\nThis will also work to end any in-progress scrolling benchmark.<reset>\n");
    sb.timer = tempTimer(5, startRun);
    sb.running = true;
  end
end

function sb.abort()
  if (sb.timer or sb.running) then
    if (sb.timer) then
      killTimer(sb.timer);
      sb.timer = nil;
    end
    sb.running = false;
    cecho("\n<red>ABORTED SCROLL BENCHMARK<reset>\n");
  else
    cecho("\n<orange>No scroll benchmark to abort.<reset>\n");
  end
end
