MODULE = Git::Raw			PACKAGE = Git::Raw::Tag

SV *
create(class, repo, name, msg, tagger, target)
	SV *class
	SV *repo
	SV *name
	SV *msg
	Signature tagger
	SV *target

	CODE:
		Tag tag;

		git_oid oid;
		git_object *obj;
		Repository r = GIT_SV_TO_PTR(Repository, repo);

		obj = git_sv_to_obj(target);

		if (obj == NULL)
			Perl_croak(aTHX_ "target is not of a valid type");

		int rc = git_tag_create(
			&oid, r, SvPVbyte_nolen(name),
			obj, tagger, SvPVbyte_nolen(msg), 0
		);
		git_check_error(rc);

		rc = git_tag_lookup(&tag, r, &oid);
		git_check_error(rc);

		GIT_NEW_OBJ(RETVAL, SvPVbyte_nolen(class), tag, SvRV(repo));

	OUTPUT: RETVAL

SV *
lookup(class, repo, id)
	SV *class
	Repository repo
	SV *id

	CODE:
		git_oid oid;
		git_object *obj;

		STRLEN len;
		const char *id_str = SvPVbyte(id, len);

		int rc = git_oid_fromstrn(&oid, id_str, len);
		git_check_error(rc);

		rc = git_object_lookup_prefix(&obj, repo, &oid, len, GIT_OBJ_TAG);
		git_check_error(rc);

		RETVAL = sv_setref_pv(newSV(0), SvPVbyte_nolen(class), obj);

	OUTPUT: RETVAL

void
foreach(class, repo, cb)
	SV *class
	SV *repo
	SV *cb

	CODE:
		git_foreach_payload payload = {
			.repo_ptr = GIT_SV_TO_PTR(Repository, repo),
			.repo     = repo,
			.cb       = cb
		};

		int rc = git_tag_foreach(payload.repo_ptr, git_tag_foreach_cbb, &payload);

		if (rc != GIT_EUSER)
			git_check_error(rc);

void
delete(class, repo, name, is_local)
	SV *class
	Repository repo
	SV *name

	CODE:
		int rc = git_tag_delete(repo, SvPVbyte_nolen(name));
		git_check_error(rc);

SV *
id(self)
	Tag self

	CODE:
		const git_oid *oid = git_tag_id(self);
		RETVAL = git_oid_to_sv((git_oid *) oid);

	OUTPUT: RETVAL

SV *
name(self)
	Tag self

	CODE:
		const char *msg = git_tag_name(self);
		RETVAL = newSVpv(msg, 0);

	OUTPUT: RETVAL

SV *
message(self)
	Tag self

	CODE:
		const char *msg = git_tag_message(self);
		RETVAL = newSVpv(msg, 0);

	OUTPUT: RETVAL

Signature
tagger(self)
	Tag self

	CODE:
		Signature c = (Signature) git_tag_tagger(self);
		RETVAL = git_signature_dup(c);

	OUTPUT: RETVAL

SV *
target(self)
	SV *self

	CODE:
		git_object *obj;

		int rc = git_tag_target(&obj, GIT_SV_TO_PTR(Tag, self));
		git_check_error(rc);

		RETVAL = git_obj_to_sv(obj, self);

	OUTPUT: RETVAL

void
DESTROY(self)
	SV *self

	CODE:
		git_tag_free(GIT_SV_TO_PTR(Tag, self));
		SvREFCNT_dec(xs_object_magic_get_struct(aTHX_ SvRV(self)));
