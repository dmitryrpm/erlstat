{application, stat,
 [{description, "stat"},
  {vsn, "0.01"},
  {modules, [
    stat,
    stat_app,
    stat_sup,
    stat_web,
    stat_deps
  ]},
  {registered, []},
  {mod, {stat_app, []}},
  {env, []},
  {applications, [kernel, stdlib, crypto]}]}.

